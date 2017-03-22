#
# Cookbook Name:: env-filesexchange
# Recipe:: _apache.rb
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

# apache
node.default['apache']['gid'] = 48
node.default['apache']['servertokens'] = 'ProductOnly'
node.default['apache']['ext_status'] = true
node.default['apache']['status_allow_list'] = '127.0.0.1 ::1'
node.default['apache']['prefork']['startservers'] = 1
node.default['apache']['prefork']['minspareservers'] = 1
node.default['apache']['prefork']['maxspareservers'] = 3
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

# add fe to apache group to allow to change group
group node['apache']['group'] do
  members node['fileexchange']['user']
end

directory node['apache']['run_dir'] do
  user node['apache']['user']
  group node['apache']['group']
end

app_info = data_bag_item('apps', 'files-exchange')
raise 'Data bag item apps/files-exchange does not exist. For details see README.md file "Data bags" section.' unless app_info['id']

template node['fileexchange']['auth_basic_file'] do
  source 'htpasswd.erb'
  variables(
    users: app_info['htpasswd']
  )
  action :create
end
