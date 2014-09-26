require 'rest-client'


# Install the pro license
ruby_block "Install Artifactory Pro license" do
  block do
    response = RestClient.post(
      "http://admin:password@localhost:8081/artifactory/api/system/license", 
      {
        "licenseKey" => "#{node[:artifactory][:pro_key]}"
      }.to_json, 
      :content_type => "application/json", :accept => "application/json"
    )
    result_json = JSON.parse(response)
    puts result_json
  end
end
