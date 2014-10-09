#
# Cookbook Name:: artifactory
# default attributes
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

# Knobs
default[:artifactory][:is_package_install] = false # set to false for manual archive install.  HUGE pain, but some shops can't handle the default RPM (e.g. user ID not artifactory 'cause too long')
default[:artifactory][:is_external_db] = true
default[:artifactory][:is_install_pro] = true
default[:artifactory][:is_ha_node] = true  #requires install_pro and a license
default[:artifactory][:import_config] = true  #requires install_pro and a license
default[:artifactory][:is_local_firewall] = true

# General installation attributes
default[:artifactory][:jfrog_base_dir] = "/opt/jfrog"
default[:artifactory][:home] = "/opt/jfrog/artifactory"
default[:artifactory][:user] = "artifactory"
default[:artifactory][:service_name] = "artifactory"
default[:artifactory][:rpm_url] = "http://172.16.18.1/jfrog/artifactory-powerpack-rpm-3.3.1.rpm"
default[:artifactory][:rpm_local_path] = "/tmp/artifactory-powerpack-rpm-3.3.1.rpm"
default[:artifactory][:rpm_package_name] = "artifactory"
default[:artifactory][:archive_name] = "artifactory-powerpack-standalone-3.3.1.zip"
default[:artifactory][:archive_extract_dir] = "artifactory-powerpack-3.3.1"
default[:artifactory][:archive_url] = "http://172.16.18.1/jfrog/artifactory-powerpack-standalone-3.3.1.zip"
default[:artifactory][:archive_local_path] = "/tmp/artifactory-powerpack-standalone-3.3.1.zip"
default[:artifactory][:import_dir] = "/tmp/config"
default[:artifactory][:cookbook_config_archive_name] = "config.zip"

# RPM and manual installs have the etc dir in different places
if (node[:artifactory][:is_package_install])
  default[:artifactory][:etc_dir] = "/var/opt/jfrog/artifactory/etc"
else
  default[:artifactory][:etc_dir] = "/opt/jfrog/artifactory/etc"
end

# HA node attributes
default[:artifactory][:ha_node_number] = "1"
default[:artifactory][:is_primary_ha_node] = true
default[:artifactory][:ha_mount_point] = "/mnt/artifactory"

# External database attributes
# Supported databases are "postgresql", "mysql", and "mssql"
default[:artifactory][:database_type] = "postgresql"
default[:artifactory][:db_jar_file]="postgresql-9.3-1102.jdbc41.jar"
#default[:artifactory][:database_type] = "mysql"
#default[:artifactory][:db_jar_file]="mysql-connector-java-5.1.33-bin.jar"
#default[:artifactory][:database_type] = "mssql"
#default[:artifactory][:db_jar_file]="sqljdbc4.jar"
default[:artifactory][:jdbc_driver_local_path] = "#{node[:artifactory][:home]}/tomcat/lib/#{node[:artifactory][:db_jar_file]}"
default[:artifactory][:jdbc_driver_url] = "http://172.16.18.1/jdbc/#{node[:artifactory][:db_jar_file]}"
