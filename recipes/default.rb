#
# Cookbook Name:: appserv-tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Rsync required, should skip if already installed
package "rsync" do
  action :install
end

# Make sure we have unzip installed, should skip if we do
package "unzip" do
  action :install
end

if (node[:artifactory][:is_local_firewall])
  # Add the Artifactory port to the firewall
  execute "firewall-cmd --zone=public --add-port=8081/tcp --permanent" do
  end

  # Reload the firewall
  execute "firewall-cmd --reload" do
  end
end

if (node[:artifactory][:is_package_install])
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
else
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
end

# Configure an external database if indicated
if (node[:artifactory][:is_external_db] or node[:artifactory][:is_ha_node])
  include_recipe "artifactory::db"
end

# Install the Pro license
if (node[:artifactory][:is_install_pro]) 
  include_recipe "artifactory::installpro"
end

# If it's an HA node, include the HA recipe
if (node[:artifactory][:is_install_pro] and node[:artifactory][:is_ha_node]) 
  include_recipe "artifactory::ha"
end

# Start up the service
service node[:artifactory][:service_name] do
  action :start
end

# Sleep a bit so the Artifactory service can come up
ruby_block "Waiting for Artifactory service" do
  block do
    artup = false
    result = nil
    while not artup do
      begin
        result = RestClient.get("http://admin:password@localhost:8081/artifactory/api/system")
        artup = true
      rescue
        sleep(2)
      end
    end
  end
end

# Import the configuration file from the cookbook. Only do this if we have a pro license. If we're doing HA, only the primary needs the import.
if (node[:artifactory][:is_install_pro] and node[:artifactory][:import_config] and !(node[:artifactory][:is_ha_node] and !node[:artifactory][:is_primary_ha_node])) 
  include_recipe "artifactory::importcfg"
end


