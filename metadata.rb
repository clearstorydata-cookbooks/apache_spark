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

name 'apache_spark'
maintainer 'ClearStory Data, Inc.'
maintainer_email 'mbautin@clearstorydata.com'
license 'Apache License 2.0'
description 'A cookbook to install and configure Apache Spark'
version '1.2.3'
source_url 'https://github.com/clearstorydata-cookbooks/apache_spark' if respond_to?(:source_url)
issues_url 'https://github.com/clearstorydata-cookbooks/apache_spark/issues' if respond_to?(:issues_url)

%w( debian ubuntu centos redhat fedora ).each do |os|
  supports os
end

depends 'apt', '~> 2.0'
depends 'java', '~> 1.0'
depends 'logrotate', '~> 1.0'
depends 'monit_wrapper', '~> 3.0'
depends 'tar'
