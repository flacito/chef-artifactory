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
execute "echo '#{node[:artifactory][:nfs_host]}:#{node[:artifactory][:nfs_directory]}  #{node[:artifactory][:ha_mount_point]}   nfs      rw,auto,noatime,nolock,bg,nfsvers=4,intr,tcp,actimeo=1800 0 0' >> /etc/fstab" do
end

# Reload fstab
execute "mount -a" do
end

# Create the HA definition
template "#{node[:artifactory][:etc_dir]}/ha-node.properties" do
  source "ha-node.properties.erb"
  variables ({
    :ha_node_id => node[:artifactory][:ha_node_id],
    :ha_mount_point => node[:artifactory][:ha_mount_point],
    :is_primary_ha_node => node[:artifactory][:is_primary_ha_node],
  })
end

# Make Artifactory user owner of HA properties file
execute "chown #{node[:artifactory][:user]} #{node[:artifactory][:etc_dir]}/ha-node.properties" do
end

# Restrict access to HA properties file
execute "chmod 644 #{node[:artifactory][:etc_dir]}/ha-node.properties" do
end
