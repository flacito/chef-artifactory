
# Create the mount point for NFS if we need to do so.
directory "#{node[:artifactory][:home]}/etc" do
  action :create
  not_if do ::File.directory?("#{node[:artifactory][:home]}/etc") end
  user node[:artifactory][:user]
end

# Create the connection definition
# db_databag = Chef::EncryptedDataBagItem.load("artifactory", "db")

template "#{node[:artifactory][:etc_dir]}/storage.properties" do
  source "#{node[:artifactory][:database_type]}.properties.erb"
  variables ({
    :db_host => data_bag_item("artifactory","db")["db_host"],
    :db_name => data_bag_item("artifactory","db")["db_name"],
    :db_user => data_bag_item("artifactory","db")["db_user"],
    :db_password => data_bag_item("artifactory","db")["db_password"]
  })
  user node[:artifactory][:user]
end

# Pull down the right JDBC driver
remote_file node[:artifactory][:jdbc_driver_local_path] do
  source node[:artifactory][:jdbc_driver_url]
  action :create
  user node[:artifactory][:user]
end

