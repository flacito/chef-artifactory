require 'rest-client'

# Add the Restlet repository
ruby_block "configure restlet repo" do
  block do
    response = RestClient.put(
      "http://localhost:8081/artifactory/api/repositories/restlet?pos=1", 
      {
        "rclass" => "remote",
        "url" => "http://maven.restlet.com",
        "description" => "RESTful Java library"
      }.to_json, 
      :content_type => "application/json", :accept => "application/json"
    )
    result_json = JSON.parse(response)
  end
end
