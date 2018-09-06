# Copyright 2015 ClearStory Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'apache_spark::spark-install'

spark_user = node['apache_spark']['user']
spark_group = node['apache_spark']['group']

if node['apache_spark']['standalone']['master_url'].nil?
  spark_master_url = "spark://#{node['apache_spark']['standalone']['master_host']}:#{node['apache_spark']['standalone']['master_port']}"
else
  spark_master_url = node['apache_spark']['standalone']['master_url']
end

directory node['apache_spark']['standalone']['worker_work_dir'] do
  mode 0755
  owner spark_user
  group spark_group
  action :create
  recursive true
end

template '/usr/local/bin/clean_spark_worker_dir.rb' do
  source 'clean_spark_worker_dir.rb.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables ruby_interpreter: RbConfig.ruby
end

worker_dir_cleanup_log = node['apache_spark']['standalone']['worker_dir_cleanup_log']
cron 'clean_spark_worker_dir' do
  minute 15
  hour 0
  command '/usr/local/bin/clean_spark_worker_dir.rb ' \
      "--worker_dir #{node['apache_spark']['standalone']['worker_work_dir']} " \
      "--days_retained #{node['apache_spark']['standalone']['job_dir_days_retained']} " \
      "--num_retained #{node['apache_spark']['standalone']['job_dir_num_retained']} " \
      "&>> #{worker_dir_cleanup_log}"
end

# logrotate for the log cleanup script
logrotate_app 'worker-dir-cleanup-log' do
  cookbook 'logrotate'
  path worker_dir_cleanup_log
  frequency 'daily'
  rotate 3  # keep this many logs
  create '0644 root root'
end

spark_user = node['apache_spark']['user']
spark_group = node['apache_spark']['group']
service_name = 'spark-standalone-worker'

worker_work_dir = node['apache_spark']['standalone']['worker_work_dir']
worker_webui_port = node['apache_spark']['standalone']['worker_webui_port']
worker_memory_mb = node['apache_spark']['standalone']['worker_memory_mb']
limit_of_file = node['apache_spark']['standalone']['max_num_open_files']
install_dir = node['apache_spark']['install_dir']
worker_bind_ip = node['apache_spark']['standalone']['worker_bind_ip']

exec = "#{install_dir}/bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port #{worker_webui_port} --work-dir #{worker_work_dir} --memory #{worker_memory_mb}m #{spark_master_url}"

if worker_bind_ip
  exec = exec + "--ip #{worker_bind_ip}"
end

systemd_service_description =
    "[Unit]
    Description=#{service_name}
    After=#{service_name}.service

[Service]
    Type=simple
    LimitNOFILE=#{limit_of_file}
    WorkingDirectory=#{node['apache_spark']['install_dir']}
    ExecStart=#{exec}
    Restart=always
    User=#{spark_user}
    Group=#{spark_group}
    Restart=on-failure
    RestartSec=15
    StartLimitInterval=10s
    StartLimitBurst=3
    StandardOutput=null
    StandardError=null

[Install]
    WantedBy=multi-user.target
"

systemd_unit "#{service_name}.service" do
  content systemd_service_description
  action [:create, :enable, :start]
end


