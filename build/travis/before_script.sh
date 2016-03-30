#!/usr/bin/env bash
set -ev
# Add repo and install apache & fastcgi.
sudo apt-get install apache2 libapache2-mod-fastcgi -yq --no-install-suggests --no-install-recommends
# Enable php-fpm.
sudo a2enmod rewrite actions fastcgi alias
cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
# Work around travis issue #3385
if [ -e ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.d/www.conf.default ]
then
  cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.d/www.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.d/www.conf
fi
echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo "error_log = /var/log/apache2/vhost_php_error.log" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo "error_log = /var/log/apache2/vhost_php_error.log" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.ini
~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm
# Disable sendmail for FPM for when serving the actual site.
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.ini
# Enable APC
echo "extension=apc.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.ini
echo "apc.shm_size=256M" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.ini
# Configure apache virtual hosts
sudo rm /etc/apache2/sites-enabled/*
cd ${TRAVIS_BUILD_DIR}/web
sudo cp -f ${TRAVIS_BUILD_DIR}/build/travis/apache-vhost.conf /etc/apache2/sites-enabled/000-default.conf
sudo sed -e "s?%BUILD_DIR%?$(pwd)?g" --in-place /etc/apache2/sites-enabled/000-default.conf
sudo service apache2 restart
