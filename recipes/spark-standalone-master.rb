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

master_runner_script = ::File.join(node['apache_spark']['install_dir'], 'bin', 'master_runner.sh')
master_service_name = 'spark-standalone-master'

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
monit_wrapper_monitor master_service_name do
  template_source 'pattern-based_service.conf.erb'
  template_cookbook 'monit_wrapper'
  variables \
    cmd_line_pattern: node['apache_spark']['standalone']['master_cmdline_pattern'],
    cmd_line: master_runner_script,
    user: spark_user,
    group: spark_group
end

monit_wrapper_service master_service_name do
  action :start

  # Determine the "notification action" based on whether the service is running at recipe compile
  # time. This is important because if the service is not running when the Chef run starts, it will
  # start as part of the :start action and pick up the new software version and configuration
  # anyway, so we don't have to restart it as part of delayed notification.
  # TODO: put this logic in a library method in monit_wrapper.
  notification_action = monit_service_exists_and_running?(master_service_name) ? :restart : :start

  subscribes notification_action, "monit-wrapper_monitor[#{master_service_name}]", :delayed
  subscribes notification_action, "package[#{node['apache_spark']['pkg_name']}]", :delayed
  subscribes notification_action, "template[#{master_runner_script}]", :delayed
end
