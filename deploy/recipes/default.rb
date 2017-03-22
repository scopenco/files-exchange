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

# instal ops tools
package ['psutils', 'vim-enhanced', 'telnet', 'lsof']

# deploy app
include_recipe 'env-files-exchange::_app'

# configure apache
include_recipe 'env-files-exchange::_apache'

# configure ftp
include_recipe 'env-files-exchange::_vsftpd'

# configure rsync
include_recipe 'env-files-exchange::_rsync'
