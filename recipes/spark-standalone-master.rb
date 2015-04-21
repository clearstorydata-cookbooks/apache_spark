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
include_recipe 'monit_wrapper'

# Do these at compile time so we can query process status at compile time.
package('monit').run_action(:install)
service('monit').run_action(:start)

master_runner_script = ::File.join(node['apache_spark']['install_dir'], 'bin', 'master_runner.sh')

spark_user = node['apache_spark']['user']
spark_group = node['apache_spark']['group']

template master_runner_script do
  source 'spark_master_runner.sh.erb'
  mode 0744
  owner spark_user
  group spark_group
  variables node['apache_spark']['standalone'].merge(
    install_dir: node['apache_spark']['install_dir']
  )
end

# Run Spark standalone master with Monit
service_name = 'spark-standalone-master'
monit_wrapper_monitor service_name do
  template_source "monit/#{service_name}.conf.erb"
  template_cookbook 'apache_spark'
  variables node['apache_spark']['standalone'].merge(
    install_dir: node['apache_spark']['install_dir'],
    master_runner_script: master_runner_script
  )
end

monit_wrapper_service service_name do
  action :start
  restart_action = monit_service_exists_and_running?(service_name) ? :restart : :start
  subscribes restart_action, "package[#{node['apache_spark']['pkg_name']}]", :delayed
  subscribes restart_action, "monit-wrapper_monitor[#{service_name}]", :delayed
  subscribes restart_action, "template[#{master_runner_script}]", :delayed
end

# ddns_alias 'spark-master' do
#   dns_master (node['ddns'] || {})['master']
#   domain (node['ddns'] || {})['domain']
#   debug true
#   only_if_configured true
# end
