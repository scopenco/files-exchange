# File Exchange Service Environment

## Desciprion

This service usefull for situation when you need to upload/download files with popular protocols like rsync, scp, ftp, webdav.

## Requirments

* Crowd==0.9.0
* Flask==0.10.1
* Flask-Mail==0.9.1
* passlib==1.6.5

## Usage

Use http://__IP__/ to access to File Exchange.

## Install
Init sqlite schema

```bash
vagrant up
vagrant ssh
sqlite3 database.db < schema.sql
```

## Auth

Supported HTTP Basic and Atlassian Crowd authentication.

### Basic 

Create htpasswd file and activate Basic Auth
```bash
htpasswd -c htpasswd test
```

### Crowd

Set Atlassian Crowd credentials for authentication in config.py.

## Authors

* Author:: Andrei Skopenko (andrei@skopenko.net)
