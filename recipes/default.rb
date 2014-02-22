#
# Cookbook Name:: appserv-tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file node[:artifactory][:rpm_local_path] do
  source node[:artifactory][:rpm_url]
  action :create
end

package "rsync" do
  action :install
end

package "iptables" do
  action :remove
end

rpm_package node[:artifactory][:rpm_package_name] do
  source node[:artifactory][:rpm_local_path]
  options "-i"
  action :install
end

service node[:artifactory][:service_name] do
  action :start
end
