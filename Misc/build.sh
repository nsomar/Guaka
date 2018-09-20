#!/bin/bash

set -ev

if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
    travis_wait swift test
else
    make test_dawrin
fi
