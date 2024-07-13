#!/bin/sh

set -ex

( ls send ./lib/* | entr -s 'cat send' ) | env CHROME_EXECUTABLE=`which chromium` flutter run -d linux
