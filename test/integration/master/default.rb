describe processes('java') do
  it { should exist }
end

describe command('ps -ef |grep java|grep "org.apache.spark.deploy.master.Master"') do
  its(:exit_status) { should eq 0 }
end

describe port(7077) do
  it { should be_listening }
end

# Spark WebUI port
describe port('18080') do
  it { should be_listening }
end

describe file('/usr/share/spark') do
  it { should exist }
  it { should be_symlink }
end

describe service('spark-standalone-master') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end