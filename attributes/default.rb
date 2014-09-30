# Knobs
default[:artifactory][:is_package_install] = false # set to false for manual archive install.  HUGE pain, but some shops can't handle the default RPM (e.g. user ID not artifactory 'cause too long')
default[:artifactory][:is_external_db] = true
default[:artifactory][:is_install_pro] = true
default[:artifactory][:is_ha_node] = true  #requires install_pro and a license
default[:artifactory][:import_config] = true  #requires install_pro and a license
default[:artifactory][:is_local_firewall] = true

# General installation attributes
default[:artifactory][:jfrog_base_dir] = "/opt/jfrog"
default[:artifactory][:home] = "#{node[:artifactory][:jfrog_base_dir]}/artifactory"
default[:artifactory][:user] = "artifactory"
default[:artifactory][:service_name] = "artifactory"
default[:artifactory][:rpm_url] = "http://172.16.18.1/jfrog/artifactory-powerpack-rpm-3.3.1.rpm"
default[:artifactory][:rpm_local_path] = "/tmp/artifactory-powerpack-rpm-3.3.1.rpm"
default[:artifactory][:rpm_package_name] = "artifactory"
default[:artifactory][:archive_name] = "artifactory-powerpack-standalone-3.3.1.zip"
default[:artifactory][:archive_extract_dir] = "artifactory-powerpack-3.3.1"
default[:artifactory][:archive_url] = "http://172.16.18.1/jfrog/#{node[:artifactory][:archive_name]}"
default[:artifactory][:archive_local_path] = "/tmp/#{node[:artifactory][:archive_name]}"
default[:artifactory][:import_base_dir] = "/tmp"
default[:artifactory][:import_dir] = "#{node[:artifactory][:import_path_root]}/config"
default[:artifactory][:cookbook_config_archive_name] = "config.zip"

# RPM and manual installs have the etc dir in different places
if (node[:artifactory][:is_package_install])
  default[:artifactory][:etc_dir] = "/var/opt/jfrog/artifactory/etc"
else
  default[:artifactory][:etc_dir] = node[:artifactory][:home]
end

# HA node attributes
default[:artifactory][:ha_node_id] = "art1"
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
