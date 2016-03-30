#!/usr/bin/env bash
set -ev
phpenv config-rm xdebug.ini
# Disable sendmail for local PHP for install.
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/sendmail_disable.ini

# Restore vendor directory from cache.
if [[ ! -d ${HOME}/vendor-cache ]]; then mkdir ${HOME}/vendor-cache; fi
echo "Vendor cache content:"
ls -lh ~/vendor-cache/
cachefile="`echo -n ${TRAVIS_PHP_VERSION} | sha1sum | cut -d " " -f 1`.tar"
if [[ -f ~/vendor-cache/${cachefile} ]]; then tar -xf ~/vendor-cache/${cachefile}; fi
if [[ -d ~/vendor/ ]]; then echo "Size of vendor directory extracted from cache:"; du -hs ~/vendor/; else echo "Vendor directory does not exist"; fi

composer --verbose self-update
composer --version
# Provide db connection string for installation.
printf "<?php\n\$databases['default']['default'] = ['database' => 'travis', 'username' => 'root', 'password' => '', 'prefix' => '', 'host' => 'localhost', 'port' => '3306', 'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql', 'driver' => 'mysql'];" > ${TRAVIS_BUILD_DIR}/web/sites/default/settings.local.php
