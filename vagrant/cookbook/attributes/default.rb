#
# Cookbook Name:: cookbook
# Attribute:: default
#
# Copyright (C) 2015 Parallels IP Holdings GmbH
#
# All rights reserved - Do Not Redistribute
#

# IUS repo
default['yum']['ius-archive']['managed'] = true
default['yum']['ius-archive']['enabled'] = true

# Python
default['python']['pip_location'] = '/usr/bin/pip2.7'

default['fileexchange']['rsyncd']['conf_file'] = '/etc/rsyncd.conf'
default['fileexchange']['rsyncd']['conf_generator'] = '/usr/bin/rsyncd.sh'
default['fileexchange']['rsyncd']['log_dir'] = '/var/log/rsync'

default['fileexchange']['data_dir'] = '/opt/data'
default['fileexchange']['app_dir'] = '/opt/filexchange'
default['fileexchange']['group'] = 'fs'
default['fileexchange']['user'] = 'fs'
default['fileexchange']['gid'] = 498
default['fileexchange']['uid'] = 498
default['fileexchange']['db_path'] = '/opt/filexchange/database.db'
default['fileexchange']['auth_basic_file'] = '/opt/filexchange/htpasswd'

default['apache']['gid'] = 48

default['vsftpd']['config'] = {
  'anonymous_enable' => 'YES',
  'write_enable' => 'YES',
  'xferlog_enable' => 'YES',
  'xferlog_file' => '/var/log/xferlog',
  'vsftpd_log_file' => '/var/log/vsftpd.log',
  'dual_log_enable' => 'YES',
  'xferlog_std_format' => 'YES',
  'log_ftp_protocol' => 'YES',
  'connect_from_port_20' => 'YES',
  'listen' => 'YES',
  'tcp_wrappers' => 'NO',
  'hide_ids' => 'YES',
  'setproctitle_enable' => 'YES',
  'max_per_ip' => '4',
  'ftp_username' => 'apache',
  'deny_file' => '{.htaccess}',
  'anon_root' => node['fileexchange']['data_dir'],
  'anon_upload_enable' => 'YES',
  'anon_mkdir_write_enable' => 'YES',
  'anon_other_write_enable' => 'YES',
  'chmod_enable' => 'NO',
  'anon_world_readable_only' => 'NO',
  'file_open_mode' => '0644',
  'anon_umask' => '022',
  'no_anon_password' => 'YES',
  'one_process_model' => 'YES',
  'max_clients' => '100'
}

default['apache']['servertokens']    = 'ProductOnly'
default['apache']['ext_status'] = true
default['apache']['status_allow_list'] = '127.0.0.1 ::1'
default['apache']['prefork']['startservers'] = 1
default['apache']['prefork']['minspareservers'] = 1
default['apache']['prefork']['maxspareservers'] = 3
