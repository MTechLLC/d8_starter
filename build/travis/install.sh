#!/usr/bin/env bash
set -ev
composer --verbose --prefer-dist install
cd ${TRAVIS_BUILD_DIR}/web
${TRAVIS_BUILD_DIR}/vendor/bin/drush site-install --verbose --yes config_installer --db-url=sqlite://tmp/site.sqlite
${TRAVIS_BUILD_DIR}/vendor/bin/drush runserver --dns localhost:8080 - &
sleep 3
