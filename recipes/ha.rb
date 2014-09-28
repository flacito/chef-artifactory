

# Create the mount point for NFS if we need to do so.
directory node[:artifactory][:ha_mount_point] do
  action :create
  not_if do ::File.directory?(node[:artifactory][:ha_mount_point]) end
end

# Mount the NFS dir
execute "mount #{node[:artifactory][:ha_nfs_server_dir]} #{[:artifactory][:ha_mount_point]}" do
end
