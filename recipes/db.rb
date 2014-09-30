#
# Cookbook Name:: artifactory
# Recipe:: db
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



# Create the mount point for NFS if we need to do so.
directory "#{node[:artifactory][:home]}/etc" do
  action :create
  not_if do ::File.directory?("#{node[:artifactory][:home]}/etc") end
  user node[:artifactory][:user]
end

# Create the connection definition
# db_databag = Chef::EncryptedDataBagItem.load("artifactory", "db")

template "#{node[:artifactory][:etc_dir]}/storage.properties" do
  source "#{node[:artifactory][:database_type]}.properties.erb"
  variables ({
    :db_host => data_bag_item("artifactory","db")["db_host"],
    :db_name => data_bag_item("artifactory","db")["db_name"],
    :db_user => data_bag_item("artifactory","db")["db_user"],
    :db_password => data_bag_item("artifactory","db")["db_password"]
  })
  user node[:artifactory][:user]
end

# Pull down the right JDBC driver
remote_file node[:artifactory][:jdbc_driver_local_path] do
  source node[:artifactory][:jdbc_driver_url]
  action :create
  user node[:artifactory][:user]
end

