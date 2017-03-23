#
# Cookbook Name:: env-filesexchange
# Attribute:: default
#
# Copyright (C) 2015 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

default['fileexchange']['repo'] = 'https://github.com/scopenco/files-exchange.git'
default['fileexchange']['revision'] = 'HEAD'
default['fileexchange']['data_dir'] = '/opt/data'
default['fileexchange']['app_dir'] = '/opt/files-exchange'
default['fileexchange']['deploy_dir'] = '/opt/fe_deploy'
default['fileexchange']['group'] = 'fs'
default['fileexchange']['user'] = 'fs'
default['fileexchange']['gid'] = 498
default['fileexchange']['uid'] = 498
default['fileexchange']['db_path'] = '/opt/files-exchange/database.db'
default['fileexchange']['auth_basic_file'] = '/opt/files-exchange/htpasswd'

# rsync settings
default['fileexchange']['rsyncd']['conf_generator'] = '/usr/bin/rsyncd.sh'
default['fileexchange']['rsyncd']['log_dir'] = '/var/log/rsync'

