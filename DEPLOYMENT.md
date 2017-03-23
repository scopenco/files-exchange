# File Exchange Service Deployment

Describe deployment in development, test and production environments

## Development environment

Based on [Vagrant](https://www.vagrantup.com/) with [Chef](https://www.chef.io/) provision.  

To create local development environment:

* Download and install [ChefDK](https://downloads.chef.io/chefdk/current/1.3.23)
* Download and install [Vagrant](https://www.vagrantup.com/downloads.html)
* Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [Parallels Desktop for Mac](http://www.parallels.com/eu/products/desktop/)
* Install vagrant plugins `vagrant plugin install vagrant-berkshelf`
* Clone github repository
```bash
git clone https://github.com/scopenco/files-exchange.git
```
* Install Gems
```bash
cd deploy
chef exec bundle
```
* Run vagrant to deploy local VM
```bash
cd deploy
vagrant up
```
* Repository will be mounted as shared folder to `/opt/files-exchange`

## Testing environment

Based on [TestKitchen](http://kitchen.ci/) included in [ChefDK](https://downloads.chef.io/chefdk/) package.

To create local test enviroment:
* Download and install [ChefDK](https://downloads.chef.io/chefdk/current/1.3.23)
* Download and install [Vagrant](https://www.vagrantup.com/downloads.html)
* Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [Parallels Desktop for Mac](http://www.parallels.com/eu/products/desktop/)
* Install vagrant plugins `vagrant plugin install vagrant-berkshelf`
* Clone github repository
```bash
git clone https://github.com/scopenco/files-exchange.git
```
* Install Gems
```bash
cd deploy
chef exec bundle
```
* Run rake tests
```bash
rake
```
Rake will run foodcritic, rubocop and serverspec tests.

## Production environment

For production deployment is possible to use one of
* [Chef Server](https://downloads.chef.io/chef-server/12.13.0)
* [Chef Server on AWS Marketplace](https://aws.amazon.com/marketplace/pp/B01AMIH01Q)
* [Chef Server on Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/chef-software.chef-server)
* [AWS OpsWorks for Chef Automate](https://aws.amazon.com/opsworks/chefautomate/)

Deployment steps:
* Create chef environment on Chef Server with Knife
```bash
 knife environment create myenv
```
* Upload cookbooks with berks and apply to new chef environment
```bash
cd deploy
berks install
berks upload
berks apply myenv
```
* Upload data bag item with knife
```bash
knife data bag from file apps files-exchange files-exchange.json --secret-file ~/.chef/data_bag_secret
```
* Bootstrap instance with knife, for example hostname `fe.domain.com`
```bash
knife bootstrap fe.domain.com --environment myenv --run-list "recipe[env-files-exchange::default]" \
    --ssh-user root --secret-file ~/.chef/data_bag_secret -N fe.domain.com
```

Please read cookbook [README.md](https://github.com/scopenco/files-exchange/blob/master/deploy/README.md) for cookbook attributes details.

# AWS deployment
TODO
