default[:artifactory][:home] = "/opt/jfrog/artifactory"

default[:artifactory][:install_pro] = true
default[:artifactory][:pro_key] = "jb12tcBe1seX6ygwcozB4dBgY0LDP0IWUrKFAkV5ZeJFbZfKFUJO1CHhyFgx3LqX/adeE0ane58S vIL0o+5ObDV1uXCoQneXeh5591Im0N0admyNO+C8r3z+i1n/CeGO4NC38gwMkTB6ZFqYdFkl0qEX spHdCfCDt9ONmtOUCJPqfpJMJHoW0u4QD56puk9gOxTnWkmRRgdtnJc+4nVokZl7eFUyKxTwtQ9C WlEkxeuG/SjIQ81Qx8OuN2amwaFkoDZcfUCZvEXFPOzPPZVYsnhByQpsmfHw0FqIqejXH1NK8gKr 3S+t7sUio2RXqJF/KLaYKJnEWP3s8hBNl+aG5cSRwcps7h4bPWP6o+CMVcPyNZ9c/asr6ViaDCi/ CyE408Ew+/ic52BvbaGtzgqfdFebpOH82+pDzm4m2YivmO+Bhh0/X1P8kGtCc/Qg1toXiZQy48gZ N+1wMrqjeL0zKxBX66qEkQAYFvNQifteJWJ9ln5hp0JU9nuGMr9ta2nS9XAaHg/dzhwaA+BstMMW BwNCXRzyCRBE085BW7F8OWX5EyG4VBX0GgO6/TOyLyn5cdh7T/Iosma+tb3Jzpw/vNOdrQEdfwGs LHedTeACEBgKVP9XtuOr+cWnuc2kLe2vfhTMGsPiwPwHge/s0Bm6xvRE5UTYLq+c7mCLIRdEsbKD zNW/fb/YszcPU3WzsRH62lTeG10qHvvfuBTd4LI5wb5pTSh7r8x9Fqlm5dzx+h1OKXGo8I06RP77 x0EK8DTSWGw2I/dwV7Y="

default[:artifactory][:import_config] = true  #requires install_pro and a license

default[:artifactory][:rpm_url] = "http://172.16.18.1/jfrog/artifactory-powerpack-rpm-3.3.1.rpm"
default[:artifactory][:rpm_local_path] = "/tmp/artifactory-powerpack-rpm-3.3.1.rpm"
default[:artifactory][:rpm_package_name] = "artifactory"
default[:artifactory][:service_name] = "artifactory"
default[:artifactory][:import_base_dir] = "/tmp"
default[:artifactory][:import_dir] = "#{node[:artifactory][:import_path_root]}/config"
default[:artifactory][:cookbook_config_archive_name] = "config.zip"

# HA node attributes
default[:artifactory][:is_ha_node] = false
default[:artifactory][:ha_mount_point] = "/mnt/artifactory"
default[:artifactory][:ha_nfs_server_dir] = "192.168.1.202:/volume1/artifactory"

# External database attributes
# Supported databases are "mysql" and "mssql"
default[:artifactory][:user_external_db] = true
default[:artifactory][:database_type] = "postgresql"
# default[:artifactory][:db_jar_file]="mysql-connector-java-5.1.33-bin.jar"
default[:artifactory][:db_jar_file]="postgresql-9.3-1102.jdbc41.jar"
default[:artifactory][:jdbc_driver_local_path] = "#{node[:artifactory][:home]}/tomcat/lib/#{node[:artifactory][:db_jar_file]}"
default[:artifactory][:jdbc_driver_url] = "http://172.16.18.1/jdbc/#{node[:artifactory][:db_jar_file]}"

# TODO Need to move these to data bag
default[:artifactory][:db_host] = "172.16.18.203"
default[:artifactory][:db_name] = "artifactory"
default[:artifactory][:db_user] = "artifactory"
default[:artifactory][:db_password] = "password"
