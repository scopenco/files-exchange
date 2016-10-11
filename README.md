# File Exchange Service Environment

## Description

This service useful for situation when you need to upload/download files with popular protocols like rsync, scp, ftp, webdav.

## View

![File Exchange Service](https://raw.githubusercontent.com/wiki/scopenco/files-exchange/images/1.png)

## Requirments

* Crowd==0.9.0
* Flask==0.10.1
* Flask-Mail==0.9.1
* passlib==1.6.5
* python-ldap==2.4.27

## Usage

Use http://__IP__/ to access to File Exchange.

## Install

* Start Vagrant

```bash
git clone https://github.com/scopenco/fileexchange.git
cd vagrant
vagrant up
vagrant ssh
```

* Init sqlite schema

```bash
sqlite3 /opt/filexchange/database.db < /opt/filexchange/schema.sql
```

* Create htpasswd file and activate Basic Auth

```bash
htpasswd -c /opt/filexchange/htpasswd test
```

## Auth

Supported:
* HTTP Basic
* Atlassian Crowd
* OpenLDAP/Active Directory

### Crowd

Set Atlassian Crowd credentials for authentication in config.py.

### OpenLDAP

Set OpenLDAP server and base dn in config.py.

## Authors

* Author:: Andrei Skopenko (andrei@skopenko.net)
