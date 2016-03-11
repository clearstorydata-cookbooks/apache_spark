require 'spec_helper'

describe 'apache_spark' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe process('java') do
    it { should be_running }
  end

  describe command('ps -ef |grep java|grep "org.apache.spark.deploy.master.Master"') do
    its(:exit_status) { should eq 0 }
  end

  describe command('ps -ef |grep java|grep "org.apache.spark.deploy.worker.Worker"') do
    its(:exit_status) { should eq 0 }
  end

  # Spark master port
  describe port(7077) do
    it { should be_listening }
  end

  # Spark master WebUI port
  describe port('8081') do
    it { should be_listening }
  end

  # Spark worker WebUI port
  describe port('18080') do
    it { should be_listening }
  end

  describe file('/usr/share/spark') do
    it { should exist }
    it { should be_symlink }
  end
end
