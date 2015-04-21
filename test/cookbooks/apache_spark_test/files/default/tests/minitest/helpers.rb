# Copyright © 2015 ClearStory Data, Inc.
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

module Helpers
  module ApacheSparkTest
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    include Chef::MonitWrapper::Status
    include Chef::MonitWrapper::StartStop

    def start_spark
      start_monit_service('spark-standalone-master')
      assert_equal('Running', get_stable_monit_service_status('spark-standalone-master'))

      start_monit_service('spark-standalone-worker')
      assert_equal('Running', get_stable_monit_service_status('spark-standalone-worker'))
    end

    def stop_spark
      stop_monit_service('spark-standalone-master')
      assert_equal('Not monitored', get_stable_monit_service_status('spark-standalone-master'))

      stop_monit_service('spark-standalone-worker')
      assert_equal('Not monitored', get_stable_monit_service_status('spark-standalone-worker'))
    end
  end
end
