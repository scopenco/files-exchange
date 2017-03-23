#
# Cookbook Name:: env-filesexchange
# Recipe:: _rsync
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

package 'rsync'

template node['fileexchange']['rsyncd']['conf_generator'] do
  mode 0o755
  variables(
    user: node['apache']['user'],
    group: node['apache']['group'],
    data_path: node['fileexchange']['data_dir'],
    rsyncd_conf: '/etc/rsyncd.conf',
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

directory node['fileexchange']['rsyncd']['log_dir'] do
  mode 0o750
  user node['apache']['user']
  group node['apache']['group']
end
