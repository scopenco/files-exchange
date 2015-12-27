#!/usr/bin/python2.7
#
# Copyright 2015 Andrei Skopenko
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
'''
Flask application realize file sharing service.
'''


from hashlib import md5
from os import chmod, chown, mkdir, urandom
from os.path import isdir, isfile
from functools import wraps
import sqlite3
import time
from datetime import datetime
import subprocess as sp
from passlib.apache import HtpasswdFile
from crowd import CrowdServer
from flask import Flask, request, render_template, \
    Response, url_for, session, redirect, g, flash, escape
from flask_mail import Mail, Message

mail = Mail()
app = Flask(__name__)
app.config.from_object('config')
mail.init_app(app)

def connect_db():
    ''' Connects to the specific database. '''
    rv_conn = sqlite3.connect(app.config['DATABASE'])
    rv_conn.row_factory = sqlite3.Row
    return rv_conn


def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db


@app.teardown_appcontext
def close_db(g):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


def basic_auth(username, password):
    ''' basic auth '''
    htpasswd_file = app.config['AUTH_BASIC_FILE']
    # return false if htpasswd not exists
    if not isfile(htpasswd_file):
        app.logger.critical("Can't read " + htpasswd_file)
        return False
    # check user and set session
    ht_file = HtpasswdFile(htpasswd_file)
    if ht_file.check_password(username, password):
        session['username'] = '%s' % username
        return True


def crowd_auth(username, password):
    ''' atlassian crowd auth '''
    cs_srv = CrowdServer(app.config['AUTH_CROWD_URL'],
                         app.config['AUTH_CROWD_USER'],
                         app.config['AUTH_CROWD_PWD'], ssl_verify=False)
    success = cs_srv.auth_user(username, password)
    if success:
        user_info = cs_srv.get_user(username)
        session['username'] = user_info['display-name']
        session['email'] = user_info['email']
        app.logger.info('user info in %(username)s / %(email)s' % session)
        return True


def check_auth(username, password):
    ''' This functon is called to check if a username /
    password combination is valid. '''
    # check crowd auth
    if app.config['AUTH'] == 'crowd':
        return crowd_auth(username, password)
    # check basic auth
    if app.config['AUTH'] == 'basic':
        return basic_auth(username, password)


def authenticate():
    ''' Sends a 401 response that enables basic auth '''
    flash('You have to login with proper credentials!')
    return Response(render_template('layout.html'), 401,
                    {'WWW-Authenticate': 'Basic realm="Login Required"'})


def require_auth(func):
    ''' Decorator for Crowd authorization '''
    @wraps(func)
    def decorated(*args, **kwargs):
        ''' decorator '''
        if 'username' not in session:
            auth = request.authorization
            if not auth or not check_auth(auth.username, auth.password):
                return authenticate()
        else:
            app.logger.debug('session exists %s' % session['username'])
        return func(*args, **kwargs)
    return decorated


def send_email(share_hash, desc):
    ''' send notification to user '''
    app.logger.debug('sending email to %s' % session['email'])
    content = {'username':session['username'],
               'hash': share_hash,
               'description': desc,
               'host': request.url_root}
    msg = Message()
    msg.add_recipient(session['email'])
    msg.sender = app.config['DEFAULT_MAIL_SENDER']
    msg.body = app.config['MAIL_MESSAGE'] % content
    msg.subject = 'Shared folder %s has been created' % share_hash
    mail.send(msg)


def create_shared_folder():
    ''' create shared folder and show instructions'''
    if 'description' not in request.form:
        flash('Failed request')
        return redirect(url_for('index'))
    # gen hash / create folder
    share_hash = md5(str(urandom(24))).hexdigest()
    shared_folder = '%s/%s' % (app.config['HOMEDIR'], share_hash)
    app.logger.info('create %s for %s' % (shared_folder, session['username']))
    mkdir(shared_folder)
    chmod(shared_folder, 0775)
    chown(shared_folder, app.config['UID'], app.config['GID'])

    # send email for crowd auth
    if 'email' in session:
        send_email(share_hash, escape(request.form['description']))

    # create record in db
    dba = get_db()
    dba.execute(
        'insert into shares '
        '(user, share, created, description) '
        'values (?, ?, ?, ?)',
        [session['username'], share_hash,
         int(time.time()), escape(request.form['description'])])
    dba.commit()

    flash('Shared folder %s has been created' % share_hash)
    return redirect(url_for('instructions',
                            share_hash=share_hash,
                            expire_days=app.config['DESTROY_TIMEOUT']))


def show_shared_folder():
    ''' show shared folders '''
    dba = get_db()
    cur = dba.execute(
        "select share, created, description "
        "from shares where user = '%s'" % session['username'])
    entries = [dict(
        share=row['share'],
        created=datetime.fromtimestamp(
            row['created']).strftime('%Y-%m-%d %H:%M'),
        destroyed=int(
            app.config['DESTROY_TIMEOUT'] - (
                int(time.time()) - row['created']) / (
                    app.config['DESTROY_TIMEOUT'] * 86400)),
        description=row['description']) for row in cur.fetchall()]
    return render_template('index.html', entries=entries)


@app.route('/instructions/<share_hash>/', methods=['GET', 'POST'])
@require_auth
def instructions(share_hash):
    ''' fuction for shared folder change '''

    # check for absent folder
    shared_folder = '%s/%s' % (app.config['HOMEDIR'], share_hash)
    if not isdir(shared_folder):
        flash('Shared folder %s not found' % share_hash)
        return redirect(url_for('index'))

    # check for owned folder
    dba = get_db()
    cur = dba.execute(
        "select created from shares where user = '%s' and share = '%s'" % (
            session['username'], share_hash))
    shared_folder_entry = cur.fetchall()
    if not shared_folder_entry:
        flash('Shared folder %s not owned by you' % share_hash)
        return redirect(url_for('index'))

    if request.method == 'POST':
        if 'readonly' in request.form:
            # doing chmod for directory
            if isdir(shared_folder):
                run_cmd = '/bin/chown -R %s.%s %s' % (
                    app.config['UID'], app.config['RO_GID'], shared_folder)
                proc = sp.Popen(
                    run_cmd, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
                state = proc.wait()
                app.logger.info('command (%s) return %s' % (run_cmd, state))
                if state > 0:
                    flash("Can't destroy shared folder %s" % share_hash)
                    return redirect(url_for('index'))
            flash('Shared folder %s has been changed to read-only'
                  % share_hash)

        if 'delete' in request.form:
            # remove directory
            if isdir(shared_folder):
                run_cmd = '/bin/rm -rf %s' % shared_folder
                proc = sp.Popen(
                    run_cmd, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
                state = proc.wait()
                app.logger.info('command (%s) return %s' % (run_cmd, state))
                if state > 0:
                    flash("Can't destroy shared folder %s" % share_hash)
                    return redirect(url_for('index'))

            # remove record from db
            dba = get_db()
            cur = dba.execute(
                "delete from shares where share = '%s'" % share_hash)
            dba.commit()

            flash('Shared folder %s has been destroyed' % share_hash)
            return redirect(url_for('index'))

    # calculate remain days before destroy
    destroyed = int(app.config['DESTROY_TIMEOUT'] - (
        int(time.time()) - shared_folder_entry[0]['created']) / (
            app.config['DESTROY_TIMEOUT'] * 86400))
    return render_template('instructions.html',
                           share_hash=share_hash,
                           expire_days=destroyed)


@app.route('/', methods=['GET', 'POST'])
@require_auth
def index():
    ''' show index '''
    if request.method == 'POST':
        return create_shared_folder()
    else:
        return show_shared_folder()


@app.errorhandler(404)
def page_not_found():
    ''' show 404 error page '''
    flash('Not found!')
    return render_template('layout.html'), 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
