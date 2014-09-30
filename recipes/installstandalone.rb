#
# Cookbook Name:: artifactory
# Recipe:: installstandalone
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


# Create the JFrog base directory
directory node[:artifactory][:jfrog_base_dir] do
  action :create
end

# Create the artifactory user
user node[:artifactory][:user] do
  action :create
  home node[:artifactory][:home]  
  uid 1001
end

# Pull down the Artifactory archive
remote_file node[:artifactory][:archive_local_path] do
  source node[:artifactory][:archive_url]
  action :create
  user node[:artifactory][:user]
end

# Extract Artifactory
execute "unzip #{node[:artifactory][:archive_name]}" do
  cwd "/tmp"
  user node[:artifactory][:user]
  not_if { File.directory?("/tmp/#{node[:artifactory][:archive_extract_dir]}") }
end

# Move artifactory
execute "mv #{node[:artifactory][:archive_extract_dir]}/* #{node[:artifactory][:home]}" do
  cwd "/tmp"
  user node[:artifactory][:user]
  not_if { File.directory?("#{node[:artifactory][:home]}/tomcat") }
end

# Install Artifactory service
execute "#{node[:artifactory][:home]}/bin/installService.sh" do
end
