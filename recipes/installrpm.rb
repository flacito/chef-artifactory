#
# Cookbook Name:: artifactory
# Recipe:: installrpm
# 
# Copyright 2014 Brian Webb
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



# Pull down the Artifactory RPM
remote_file node[:artifactory][:rpm_local_path] do
  source node[:artifactory][:rpm_url]
  action :create
end

# Install the Artifactory RPM
rpm_package node[:artifactory][:rpm_package_name] do
  source node[:artifactory][:rpm_local_path]
  options "-i"
  action :install
end
