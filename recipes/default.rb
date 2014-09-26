#
# Cookbook Name:: appserv-tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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
