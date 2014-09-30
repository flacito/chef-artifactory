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
