# File Exchange Environment Cookbook

This cookbook is based on [The Environment Cookbook Pattern](http://blog.vialstudios.com/the-environment-cookbook-pattern/) and deploy
File Exchange service.

## Requirements

### Cookbooks

The following cookbooks are direct dependencies because they're used for common "default" functionality.

- [yum-epel](https://supermarket.chef.io/cookbooks/yum-epel)
- [python](https://supermarket.chef.io/cookbooks/python)
- [vsftpd](https://supermarket.chef.io/cookbooks/vsftpd)
- [xinetd](https://supermarket.chef.io/cookbooks/xinetd)
- [apache2](https://supermarket.chef.io/cookbooks/apache2)
- [user](https://supermarket.chef.io/cookbooks/user)
- [simple_iptables](https://supermarket.chef.io/cookbooks/simple_iptables)

### Platforms

Tested on CentOS 7.x

### Chef

Tested on ChefDK 1.3.23

## Attributes

Node attributes for this cookbook are logically separated into different files. Some attributes are set only via a specific recipe.

- `node['fileexchange']['repo']` - The url to the source git repo on github, default 'https://github.com/scopenco/files-exchange.git'
- `node['fileexchange']['revision']` - git reference in source code that should be deployed, default 'HEAD'
- `node['fileexchange']['data_dir']` - local directory for shared files, default '/opt/data'
- `node['fileexchange']['app_dir']` - application directory. For Vagrant it's mounted to repo root, for other it's symlink to source code revison, default '/opt/files-exchange'
- `node['fileexchange']['deploy_dir']` - deployment directory, used only for source code deployment, default '/opt/fe_deploy'
- `node['fileexchange']['user']` - run backend with users permissions, default 'fs'
- `node['fileexchange']['group']` - run backend with group permissions, default 'fs'
- `node['fileexchange']['uid']` - user uid, default '498'
- `node['fileexchange']['gid']` - group gid, default '498'
- `node['fileexchange']['db_path']` - path to sqlite database, default '/opt/files-exchange/database.db'
- `node['fileexchange']['auth_basic_file']` - path to htpasswd file used for HTTP base auth, default '/opt/files-exchange/htpasswd'
- `node['fileexchange']['rsync']['conf_generator']` - path to script that generate rsyncd.conf
- `node['fileexchange']['rsync']['log_dir']` - rsync service log path

## Recipes

* `default` - configure file exchange service
* `_apache` - configure apache
* `_app` - install python libs, deploy application
* `_rsync` - configure rsync as daemon
* `_vsftpd` - configure vsftpd

## Data bags

```json
{
  "id": "files-exchange",
  "htpasswd": {
    "test01": "test01",
    "test02": "test02"
  }
}
```

Data bag store htpasswd credentials. For production deployment should be used [encrypted data bags](https://docs.chef.io/data_bags.html#encrypt-a-data-bag-item).

## Authors

* Author:: Andrei Skopenko (andrei@skopenko.net)

## Copyright & License

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>
