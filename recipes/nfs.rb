#
# Cookbook Name:: nfs
# Recipe:: nfs
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

# Create the mount point for the NFS share
directory "#{node[:artifactory][:ha_mount_point]}" do
  action :create
  owner node[:artifactory][:user]
end

# Put the mount for the NFS share in fstab
execute "echo '#{Chef::EncryptedDataBagItem.load("artifactory", "ha")["nfs_host"]}:#{Chef::EncryptedDataBagItem.load("artifactory", "ha")["nfs_directory"]}  #{node[:artifactory][:ha_mount_point]}   nfs      rw,auto,noatime,nolock,bg,nfsvers=4,intr,tcp,actimeo=1800 0 0' >> /etc/fstab" do
end

# Reload fstab, making the NFS share active
execute "mount -a" do
end
