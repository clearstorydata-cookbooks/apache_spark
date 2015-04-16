chef_gem 'waitutil'

include_recipe 'apache_spark::force-apt-update'
include_recipe 'java'
include_recipe 'apache_spark::spark-install'
include_recipe 'apache_spark::spark-standalone-master'
include_recipe 'apache_spark::spark-standalone-worker'
