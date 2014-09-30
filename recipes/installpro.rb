require 'rest-client'

# Create the license file
template "#{node[:artifactory][:etc_dir]}/artifactory.lic" do
  source "artifactory.lic.erb"
  variables ({
    :pro_key => node[:artifactory][:license]
  })
end
