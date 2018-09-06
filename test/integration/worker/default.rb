describe command('ps -ef |grep java|grep "org.apache.spark.deploy.worker.Worker"') do
  its(:exit_status) { should eq 0 }
end

# Spark WebUI port
describe port(8081) do
  it { should be_listening }
end

describe file('/usr/share/spark') do
  it { should exist }
  it { should be_symlink }
end

describe service('spark-standalone-worker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end