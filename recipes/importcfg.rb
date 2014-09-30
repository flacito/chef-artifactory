require 'rest-client'

# Load the config archive onto the system
cookbook_file node[:artifactory][:cookbook_config_archive_name] do
  path "#{node[:artifactory][:import_base_dir]}/#{node[:artifactory][:cookbook_config_archive_name]}"
  action :create_if_missing
end

# Extract the archive
execute "unzip #{node[:artifactory][:import_base_dir]}/#{node[:artifactory][:cookbook_config_archive_name]} -d #{node[:artifactory][:import_dir]}" do
   not_if do ::File.directory?(node[:artifactory][:import_dir]) end
end

# Import the configuration
ruby_block "import Artifactory config" do
  block do
    response = RestClient.post(
      "http://admin:password@localhost:8081/artifactory/api/import/system", 
      {
        "importPath" => node[:artifactory][:import_dir],
        "includeMetadata" => false,
        "verbose" => false,
        "failOnError" => true,
        "failIfEmpty" => true
      }.to_json, 
      :content_type => "application/json", :accept => "application/json"
    )
    # result_json = JSON.parse(response)
    # puts result_json
  end
end
