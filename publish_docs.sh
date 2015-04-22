#!/bin/bash

set -euxo pipefail
cd `dirname $0`
bundle install
rm -rf doc
bundle exec yardoc
mkdir -p build
cd build
rm -rf ./apache_spark
git clone git@github.com:clearstorydata-cookbooks/apache_spark.git
cd apache_spark
if git branch -a | grep gh-pages; then
  git checkout gh-pages
else
  git checkout -b gh-pages
fi
rm -rf ./*
cp -R ../../doc/* .

find . -name "*.html" -exec sed -i -s 's/"_index.html"/"index.html"/g' {} \;
find . -name "*.html" -exec sed -i -s 's/\/_index.html/\/index.html/g' {} \;
find . -name "*.html" -exec sed -i -s 's/#!_index.html/#!index.html/g' {} \;

git add -A
git commit -a -m "Updating documentation (user: $USER, timestamp: `date`)"
git push origin
