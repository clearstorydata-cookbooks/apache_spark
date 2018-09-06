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
service_name = 'spark-standalone-master'

master_bind_ip = node['apache_spark']['standalone']['master_bind_ip']
master_port = node['apache_spark']['standalone']['master_port']
master_webui_port = node['apache_spark']['standalone']['master_webui_port']
install_dir = node['apache_spark']['install_dir']
limit_of_file = node['apache_spark']['standalone']['max_num_open_files']

exec = "#{install_dir}/bin/spark-class org.apache.spark.deploy.master.Master --ip #{master_bind_ip} --webui-port #{master_webui_port} --port #{master_port}"

systemd_service_description =
"[Unit]
    Description=#{service_name}
    After=#{service_name}.service

[Service]
    Type=simple
    LimitNOFILE=#{limit_of_file}
    WorkingDirectory=#{install_dir}
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
