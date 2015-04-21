#!/bin/bash

set -euxo pipefail
cd `dirname $0`
bundle install
rm -rf doc
bundle exec yardoc
mkdir -p build
cd build
rm -rf ./monit_wrapper
git clone git@github.com:clearstorydata-cookbooks/monit_wrapper.git
cd monit_wrapper
git checkout gh-pages
rm -rf ./*
cp -R ../../doc/* .

find . -name "*.html" -exec sed -i -s 's/"_index.html"/"index.html"/g' {} \;
find . -name "*.html" -exec sed -i -s 's/\/_index.html/\/index.html/g' {} \;
find . -name "*.html" -exec sed -i -s 's/#!_index.html/#!index.html/g' {} \;

git add -A
git commit -a -m "Updating documentation (user: $USER, timestamp: `date`)"
git push origin
