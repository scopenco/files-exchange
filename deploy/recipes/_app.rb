#
# Cookbook Name:: env-filesexchange
# Recipe:: _app
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

# install epel repo
include_recipe 'yum-epel'

# install python with deps
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

# create user/group
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

package 'git'

# check if we are using vagrant mount point
cmd = Mixlib::ShellOut.new("mountpoint #{node['fileexchange']['app_dir']}")
is_shared_folder = cmd.run_command.stdout.include?('is a mountpoint')

if is_shared_folder
  directory ::File.join(node['fileexchange']['deploy_dir'], 'shared') do
    mode 0o755
    user node['fileexchange']['user']
    group node['fileexchange']['group']
    recursive true
  end

  template ::File.join(node['fileexchange']['app_dir'], 'config.py') do
    mode 0o644
    variables(
      db_path: File.join(node['fileexchange']['deploy_dir'], 'shared', 'database.db'),
      data_path: node['fileexchange']['data_dir'],
      uid: node['fileexchange']['uid'],
      gid: node['apache']['gid'],
      ro_gid: node['fileexchange']['gid'],
      auth_basic_file: node['fileexchange']['auth_basic_file']
    )
  end

  template ::File.join(node['fileexchange']['app_dir'], 'wsgi.py') do
    mode 0o644
    variables(
      app_path: node['fileexchange']['app_dir']
    )
  end
else

  # deploy app
  deploy_revision node['fileexchange']['deploy_dir'] do
    repo node['fileexchange']['repo']
    revision node['fileexchange']['revision']
    migrate false
    symlink_before_migrate({})
    create_dirs_before_symlink []
    purge_before_symlink []
    keep_releases 5

    symlinks(
      'config.py' => 'config.py',
      'wsgi.py' => 'wsgi.py'
    )

    before_symlink do
      directory shared_path do
        user node['fileexchange']['user']
        group node['fileexchange']['group']
        mode '0755'
      end

      template ::File.join(shared_path, 'config.py') do
        mode 0o644
        variables(
          db_path: File.join(shared_path, 'database.db'),
          data_path: node['fileexchange']['data_dir'],
          uid: node['fileexchange']['uid'],
          gid: node['apache']['gid'],
          ro_gid: node['fileexchange']['gid'],
          auth_basic_file: node['fileexchange']['auth_basic_file']
        )
      end

      template ::File.join(shared_path, 'wsgi.py') do
        mode 0o644
        variables(
          app_path: node['fileexchange']['app_dir']
        )
      end
    end

    before_restart do
      link node['fileexchange']['app_dir'] do
        to release_path
      end
    end

    notifies :restart, 'service[apache2]', :delayed
  end

end

db_file = ::File.join(node['fileexchange']['deploy_dir'], 'shared', 'database.db')
execute "sqlite3 #{db_file} < #{node['fileexchange']['app_dir']}/schema.sql" do
  creates db_file
  action :run
end

file db_file do
  mode 0o640
  user node['fileexchange']['user']
  group node['fileexchange']['group']
end

# shares home dir
directory node['fileexchange']['data_dir'] do
  user node['fileexchange']['user']
  group 'root'
  mode 0o751
end

# configure base auth users
app_info = data_bag_item('apps', 'files-exchange')
raise 'Data bag item apps/files-exchange does not exist. For details see README.md file "Data bags" section.' unless app_info['id']

template node['fileexchange']['auth_basic_file'] do
  source 'htpasswd.erb'
  variables(
    users: app_info['htpasswd']
  )
  action :create
end
