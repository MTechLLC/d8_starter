#!/usr/bin/env bash
set -ev
# Run core's PHPUnit tests cause they are fast.
cd ${TRAVIS_BUILD_DIR}/web
$(phpenv which php) ./core/scripts/run-tests.sh --php $(phpenv which php) --sqlite ${TRAVIS_BUILD_DIR}/travis.sqlite PHPUnit
# Run PhantomJS.
mkdir /tmp/pjsdrivercache/phantomjs
phantomjs --ssl-protocol=any --ignore-ssl-errors=true ~/vendor/jcalderonzumba/gastonjs/src/Client/main.js 8510 1024 768 2>&1 > /tmp/gastonjs.log &
# Install & run Behat tests.
cd ${TRAVIS_BUILD_DIR}/test
${TRAVIS_BUILD_DIR}/vendor/bin/behat --version
${TRAVIS_BUILD_DIR}/vendor/bin/behat
