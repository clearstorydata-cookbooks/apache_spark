source 'https://api.berkshelf.com'

metadata

cookbook 'monit', github: 'phlipper/chef-monit', tag: '1.5.2'

group :integration do
  cookbook 'hadoop'
  cookbook 'minitest-handler'
  cookbook 'apache_spark_test', path: 'test/cookbooks/apache_spark_test'
end
