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

require 'ostruct'
require 'pp'
require 'waitutil'
require 'yaml'

require_relative 'helpers'

describe_recipe 'apache_spark::spark-install' do

  include Helpers::ApacheSparkTest

  it 'allows starting Spark standalone master' do
    stop_spark

    start_monit_service('spark-standalone-master')
    assert_equal('Running', get_stable_monit_service_status('spark-standalone-master'))

    # The worker should still be down.
    assert_equal('Not monitored', get_stable_monit_service_status('spark-standalone-worker'))
  end

  it 'allows starting Spark standalone worker' do
    stop_spark

    start_monit_service('spark-standalone-worker')
    assert_equal('Running', get_stable_monit_service_status('spark-standalone-worker'))

    # The master should still be down.
    assert_equal('Not monitored', get_stable_monit_service_status('spark-standalone-master'))
  end

end
