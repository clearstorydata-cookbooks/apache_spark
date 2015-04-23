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

case node['platform']
when 'debian', 'ubuntu'
  execute 'apt-get update' do
    command 'apt-get update'
    action :nothing
  end.run_action(:run)
when 'redhat', 'centos', 'fedora'
  execute 'apt-get update' do
    command <<-EOT
      yum check-update
      exit_code=$?
      if [ "${exit_code}" -eq 100 ]; then
        # yum returns 100 when there are updates available.
        exit_code=0
      fi
      exit "${exit_code}"
    EOT
    action :nothing
  end.run_action(:run)
else
  Chef::Log.info("Cannot update package index for platform #{node['platform']} -- doing nothing")
end
