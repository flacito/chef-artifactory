#
# Cookbook Name:: artifactory
# Recipe:: ha
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


# Install NFS utilities
package "nfs-utils" do
  action :install
end

# More NFS utilities 
package "nfs-utils-lib" do
  action :install
end

# Create the mount point
directory "#{node[:artifactory][:ha_mount_point]}" do
  action :create
  owner node[:artifactory][:user]
end

# Put the mount in fstab
execute "echo '#{data_bag_item("artifactory", "ha")["nfs_host"]}:#{data_bag_item("artifactory", "ha")["nfs_directory"]}  #{node[:artifactory][:ha_mount_point]}   nfs      rw,auto,noatime,nolock,bg,nfsvers=4,intr,tcp,actimeo=1800 0 0' >> /etc/fstab" do
end

# Reload fstab
execute "mount -a" do
end

# Create the HA definition
template "#{node[:artifactory][:etc_dir]}/ha-node.properties" do
  source "ha-node.properties.erb"
  variables ({
    :ha_node_id => "art#{node[:artifactory][:ha_node_number]}",
    :ha_mount_point => node[:artifactory][:ha_mount_point],
    :is_primary_ha_node => node[:artifactory][:is_primary_ha_node],
  })
  user node[:artifactory][:user]
end

# Restrict access to HA properties file
execute "chmod 644 #{node[:artifactory][:etc_dir]}/ha-node.properties" do
end
