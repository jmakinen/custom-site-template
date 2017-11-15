# VVV Custom site template
For when you just need a simple Drupal dev site

## Overview
This template will allow you to create a Drupal dev environment using only `vvv-custom.yml`.


# Installation
`git clone -b master git://github.com/Varying-Vagrant-Vagrants/VVV.git ~/vagrant-local`

# Configuration

## The minimum required configuration:

```
---
sites:
  drupal:
    repo: https://github.com/jmakinen/custom-site-template
    hosts:
      - drupal.dev

utilities:
  core:
    - memcached-admin
    - opcache-status
    - phpmyadmin
    - webgrind
```

# Running

```
vagrant up --provision
```

# Drush
Drush 9 beta is installed. You may have to specify Drupal root like
`drush --root=/srv/www/drupal/public_html <command>`
  
