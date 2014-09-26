#
# Cookbook Name:: appserv-tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# If it's an HA node, have to mount NFS
if (node[:artifactory][:is_ha_node]) 
  directory node[:artifactory][:ha_mount_point] do
    action :create
    not_if do ::File.directory?(node[:artifactory][:ha_mount_point]) end
  end
  
  execute "mount #{node[:artifactory][:ha_nfs_server]} #{[:artifactory][:ha_mount_point]}" do
  end
end

# Pull down the Artifactory RPM
remote_file node[:artifactory][:rpm_local_path] do
  source node[:artifactory][:rpm_url]
  action :create
end

# Rsync required, should skip if already installed
package "rsync" do
  action :install
end

# Add the Artifactory port to the firewall
execute "firewall-cmd --zone=public --add-port=8081/tcp --permanent" do
end

# Reload the firewall
execute "firewall-cmd --reload" do
end

# Install the Artifactory RPM
rpm_package node[:artifactory][:rpm_package_name] do
  source node[:artifactory][:rpm_local_path]
  options "-i"
  action :install
end

# Start up the service
service node[:artifactory][:service_name] do
  action :start
end

# Sleep a bit so the Artifactory service can come up
ruby_block "Waiting for Artifactory service" do
  block do
    artup = false
    while not artup do
      begin
        RestClient.get("http://admin:password@localhost:8081/artifactory/api/system")
        artup = true
      rescue
        sleep(2)
      end
    end
  end
end
