# VVV Custom site template
For when you just need a simple Drupal dev site

## Overview
This template will allow you to create a Drupal dev environment using only `vvv-custom.yml`.


# Installation
`git clone -b master git://github.com/Varying-Vagrant-Vagrants/VVV.git ~/vagrant-local`

# Configuration

## The minimum required configuration:
Create (or modify if you have one already) `vvv-custom.yml` under `~/vagrant-local`
```
---
sites:
  drupal:
    repo: https://github.com/jmakinen/custom-site-template
    hosts:
      - drupal.dev
    nginx_upstream: php71 

utilities:
  core:
    - memcached-admin
    - opcache-status
    - phpmyadmin
    - webgrind
    - php71
```

# Running

```
vagrant up --provision
```

# Drush
Drush 9 beta is installed. You may have to specify Drupal root like
`drush --root=/srv/www/drupal/public_html <command>`
  
