#
# Cookbook Name:: artifactory
# Recipe:: repos
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
