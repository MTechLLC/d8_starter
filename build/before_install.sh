#!/usr/bin/env bash
set -ev
phpenv config-rm xdebug.ini
# Disable sendmail for local PHP for install.
echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/sendmail_disable.ini

# Create an hash corresponding to the PHP version.
echo "Vendor cache content:"
ls -lh ${HOME}/vendor-cache/
cachefile="`echo -n ${TRAVIS_PHP_VERSION} | sha1sum | cut -d " " -f 1`.tar"
echo "cachefile = ${cachefile}"
[[ -f ${HOME}/vendor-cache/${cachefile} ]];
then
  tar -xf ${HOME}/vendor-cache/${cachefile}
fi
if [[ -d ${HOME}/vendor/ ]]
then
  echo "Size of vendor directory extracted from cache:"
  du -hs ${HOME}/vendor/
else
  echo "vendor directory does not exist"
fi


composer --verbose self-update
composer --version
# Provide db connection string for installation.
printf "<?php\n\$databases['default']['default'] = ['database' => 'travis', 'username' => 'root', 'password' => '', 'prefix' => '', 'host' => 'localhost', 'port' => '3306', 'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql', 'driver' => 'mysql'];" > ${TRAVIS_BUILD_DIR}/web/sites/default/settings.local.php
