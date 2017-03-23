#
# Cookbook Name:: env-filesexchange
# Recipe:: /_vsftpd
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

node.default['vsftpd']['config'] = {
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
  'max_clients' => '100',
}
include_recipe 'vsftpd'
