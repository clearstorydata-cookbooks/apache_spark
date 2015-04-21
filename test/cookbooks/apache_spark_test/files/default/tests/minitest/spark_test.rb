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

  it 'allows to run a Spark program (SparkPi)' do
    spark_install_dir = node['apache_spark']['install_dir']
    spark_examples_jars = Dir["/usr/share/spark/lib/spark-examples-*.jar"]
    assert_equal(1, spark_examples_jars.length,
      "Expected exactly one Spark examples jar but found #{spark_examples_jars}.")
    spark_examples_jar = spark_examples_jars.first

    start_spark
    spark_pi_result = shell_out!(
      "sudo -u spark #{spark_install_dir}/bin/spark-submit " \
      "--class org.apache.spark.examples.SparkPi " \
      "--deploy-mode client " \
      "--master spark://localhost:7077 " \
      "#{spark_examples_jar} 100")
    expected_msg = 'Pi is roughly 3.14'
    assert(
      spark_pi_result.stdout.include?(expected_msg),
      "Expected stdout to say '#{expected_msg}'. " \
      "Actual stdout:\n#{spark_pi_result.stdout}\n\nStderr:\n#{spark_pi_result.stderr}")
  end

end
