require 'rest-client'

# Create the license file
template "#{node[:artifactory][:etc_dir]}/artifactory.lic" do
  source "artifactory.lic.erb"
  variables ({
    :pro_key => node[:artifactory][:pro_key],
  })
end

# Install the pro license from the RESTful WS
# ruby_block "Install Artifactory Pro license" do
#   block do
#     response = RestClient.post(
#       "http://admin:password@localhost:8081/artifactory/api/system/license", 
#       {
#         "licenseKey" => "#{node[:artifactory][:pro_key]}"
#       }.to_json, 
#       :content_type => "application/json", :accept => "application/json"
#     )
#     result_json = JSON.parse(response)
#     puts result_json
#   end
# end
