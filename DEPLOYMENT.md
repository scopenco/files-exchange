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
```
git clone https://github.com/scopenco/files-exchange.git
```
* Install Gems
```
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
```
git clone https://github.com/scopenco/files-exchange.git
```
* Install Gems
```
cd deploy
chef exec bundle
```
* Run rake tests
```
rake
```
Rake will run foodcritic, rubocop and serverspec tests.

## Production environment

Please read cookbook [README.md](https://github.com/scopenco/files-exchange/blob/master/deploy/README.md) for cookbook attributes details.
