
# Create the mount point for NFS if we need to do so.
directory "#{node[:artifactory][:home]}/etc" do
  action :create
  not_if do ::File.directory?("#{node[:artifactory][:home]}/etc") end
end

# Create the connection definition
template "#{node[:artifactory][:etc_dir]}/storage.properties" do
  source "#{node[:artifactory][:database_type]}.properties.erb"
  variables ({
    :db_host => node[:artifactory][:db_host],
    :db_name => node[:artifactory][:db_name],
    :db_user => node[:artifactory][:db_user],
    :db_password => node[:artifactory][:db_password],
  })
end

# Pull down the right JDBC driver
remote_file node[:artifactory][:jdbc_driver_local_path] do
  source node[:artifactory][:jdbc_driver_url]
  action :create
end

