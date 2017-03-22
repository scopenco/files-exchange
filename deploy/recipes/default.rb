#
# Cookbook Name:: env-filesexchange
# Recipe:: default
#
# Copyright 2016-2017 Andrei Skopenko
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

# remove unused local packages in PD
package ['rpcbind', 'nfs-utils'] do
  action :remove
end

include_recipe 'yum-epel'

package ['git', 'psutils', 'vim-enhanced', 'telnet', 'lsof', 'rsync']

# application deployment
package ['gcc', 'openldap-devel']
package ['python', 'python-pip', 'python-setuptools', 'python-devel']
python_pip 'flask' do
  version '0.10.1'
end
python_pip 'crowd' do
  version '0.9.0'
end
python_pip 'flask-mail'
python_pip 'passlib'
python_pip 'python-ldap'

group node['fileexchange']['group'] do
  gid node['fileexchange']['gid']
  action :create
end

user node['fileexchange']['user'] do
  comment 'fileexchange user'
  shell '/bin/bash'
  home '/opt/data'
  uid node['fileexchange']['uid']
  gid node['fileexchange']['group']
  action :create
end

# home dir
directory node['fileexchange']['data_dir'] do
  user node['fileexchange']['user']
  group 'root'
  mode 0o751
end

# ftp
include_recipe 'vsftpd'

# apache
include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_dav'
include_recipe 'apache2::mod_dav_fs'

package 'mod_wsgi'
template ::File.join(node['apache']['dir'], 'conf-available', 'fileexchange.conf') do
  source 'httpd.conf.erb'
  variables(
    data_path: node['fileexchange']['data_dir'],
    app_path: node['fileexchange']['app_dir'],
    user: node['fileexchange']['user'],
    group: node['fileexchange']['group']
  )
  notifies :reload, 'service[apache2]'
end
apache_config 'fileexchange'

# rsync
template node['fileexchange']['rsyncd']['conf_generator'] do
  mode 0o755
  variables(
    user: node['apache']['user'],
    group: node['apache']['group'],
    data_path: node['fileexchange']['data_dir'],
    rsyncd_conf: node['fileexchange']['rsyncd']['conf_file'],
    log_path: node['fileexchange']['rsyncd']['log_dir']
  )
end

include_recipe 'xinetd'
xinetd_service 'rsync' do
  socket_type 'stream'
  wait false
  user 'root'
  server node['fileexchange']['rsyncd']['conf_generator']
  log_on_failure 'USERID'
  action :enable
end

# add fe to apache group to allow to change group
group node['apache']['group'] do
  members node['fileexchange']['user']
end

directory node['apache']['run_dir'] do
  user node['apache']['user']
  group node['apache']['group']
end

directory node['fileexchange']['rsyncd']['log_dir'] do
  mode 0o750
  user node['apache']['user']
  group node['apache']['group']
end

file node['fileexchange']['auth_basic_file'] do
  not_if { ::File.exist?(node['fileexchange']['auth_basic_file']) }
  content 'test:test'
  action :create
end

execute "sqlite3 #{node['fileexchange']['db_path']} < #{node['fileexchange']['app_dir']}/schema.sql" do
  creates ::File.join(node['fileexchange']['app_dir'], 'database.db')
  action :run
end

template ::File.join(node['fileexchange']['app_dir'], 'config.py') do
  mode 0o644
  variables(
    db_path: node['fileexchange']['db_path'],
    data_path: node['fileexchange']['data_dir'],
    uid: node['fileexchange']['uid'],
    gid: node['apache']['gid'],
    ro_gid: node['fileexchange']['gid'],
    auth_basic_file: node['fileexchange']['auth_basic_file']
  )
end
