#
# Cookbook Name:: artifactory
# Recipe:: default
#
# Copyright 2014, Brian T. Webb
#
# All rights reserved - Do Not Redistribute
#

# Make sure we have rsync
package "rsync" do
  action :install
end

# Make sure we have unzip installed
package "unzip" do
  action :install
end

# Local firewall settings if needed
if (node[:artifactory][:is_local_firewall])
  # Add the Artifactory port to the firewall
  execute "firewall-cmd --zone=public --add-port=8081/tcp --permanent" do
  end

  # Reload the firewall
  execute "firewall-cmd --reload" do
  end
end

# Install base Artifactory 
if (node[:artifactory][:is_package_install])
  include_recipe "artifactory::installrpm"
else
  include_recipe "artifactory::installstandalone"
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

# Import the configuration file from the cookbook. Only do this if we have a pro license. If we're doing HA, only the primary needs the import.
if (node[:artifactory][:is_install_pro] and node[:artifactory][:import_config] and !(node[:artifactory][:is_ha_node] and !node[:artifactory][:is_primary_ha_node])) 
  include_recipe "artifactory::importcfg"
end


