chef_gem 'waitutil'

include_recipe 'apache_spark::force-apt-update'
include_recipe 'java'
include_recipe 'hadoop'
include_recipe 'hadoop::hadoop_hdfs_namenode'
include_recipe 'hadoop::hadoop_hdfs_datanode'

# Stop datanode/namenode in case we are running these tests multiple times on the same VM.
service 'hadoop-hdfs-datanode' do
  action :stop
end

service 'hadoop-hdfs-namenode' do
  action :stop
end

# Try to reformat the namenode. Ignore failures here -- formatting will only happen once.
execute 'hdfs-namenode-format' do
  action :run
  ignore_failure true
end

# Start namenode/datanode.
service 'hadoop-hdfs-namenode' do
  action :start
end

service 'hadoop-hdfs-datanode' do
  action :start
end

include_recipe 'apache_spark::spark-install'
include_recipe 'apache_spark::spark-standalone-master'
include_recipe 'apache_spark::spark-standalone-worker'
