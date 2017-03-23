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

Use http://__IP__/ (for Vagrant on VirtualBox use port 8080) to access to File Exchange.

## Auth

Supported:
* HTTP Basic
* Atlassian Crowd
* OpenLDAP/Active Directory

### Crowd

Set Atlassian Crowd credentials for authentication in config.py.

### OpenLDAP

Set OpenLDAP server and base dn in config.py.

## Development & Deployment

Based on [Vagrant](http://www.vagrantup.com/) with [Chef](https://www.chef.io/) provision.
Please read [DEPLOYMENT.md](https://github.com/scopenco/files-exchange/blob/master/DEPLOYMENT.md) for details.

## TODO

* add unit tests
* switch to setuptools

## Contributing

2. Fork the repository on Github
3. Create a named feature branch (like `add_component_x`)
4. Write your change
5. Write tests for your change (if applicable)
6. Run the tests (`rake`), ensuring they all pass
7. Write new resource/attribute description to `README.md`
9. Submit a Pull Request using Github

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
