#
# Cookbook Name:: artifactory
# Recipe:: importcfg
# 
# Copyright 2014 Brian Webb
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


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
