#!/usr/bin/env bash
set -ev
mysql -e 'create database IF NOT EXISTS travis;' -uroot
composer --verbose --prefer-dist install
phpenv rehash
cd ${TRAVIS_BUILD_DIR}/web
${TRAVIS_BUILD_DIR}/vendor/bin/drush site-install config_installer -y --verbose --db-url=mysql://root:@127.0.0.1/travis --db-su='root' --db-su-pw=''

# Install phantomjs
sudo apt-get update; sudo apt-get install libicu52
cd ${TRAVIS_BUILD_DIR}
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar jxf phantomjs-2.1.1-linux-x86_64.tar.bz2
chmod 755 ${TRAVIS_BUILD_DIR}/phantomjs-2.1.1-linux-x86_64/bin/phantomjs
sudo ln -s --force ~/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
mkdir /tmp/pjsdrivercache/phantomjs
