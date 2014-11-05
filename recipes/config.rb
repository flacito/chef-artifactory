#
# Cookbook Name:: artifactory
# Recipe:: config
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

# Create the directory for the config import
directory "#{node[:artifactory][:import_dir]}" do
  action :create
  owner node[:artifactory][:user]
end

# Extract the config archive
execute "tar zxf #{node[:artifactory][:import_base_dir]}/#{node[:artifactory][:cookbook_config_archive_name]} -C #{node[:artifactory][:import_dir]}" do
  user node[:artifactory][:user]
end

# The easy part: overlay the initial configuration from the Chef template
dbagi = Chef::EncryptedDataBagItem.load("artifactory", "security")["ldapSettings"][0]
template "#{node[:artifactory][:import_dir]}/artifactory.config.xml" do
  source "artifactory.config.xml.erb"
  variables ({
    # URL Base for VIP
    :url_base => "http://#{data_bag_item("artifactory", "ha")["vip"]}/artifactory",

    # LDAP setup
    :key => dbagi['key'],
    :enabled => dbagi['enabled'],
    :ldapUrl => dbagi['ldapUrl'],
    :searchFilter => dbagi['search']['searchFilter'],
    :searchBase => dbagi['search']['searchBase'],
    :managerDn => dbagi['search']['managerDn'],
    :managerPassword => dbagi['search']['managerPassword'],
    :autoCreateUser => dbagi['autoCreateUser'],
    :emailAttribute => dbagi['emailAttribute'],

    # SSO (kerberos)
    :httpSsoProxied => dbagi['httpSsoProxiednoAutoUserCreation'],
    :url_base => dbagi['noAutoUserCreation'],
    :url_base => dbagi['remoteUserRequestVariable'],
  })
  user node[:artifactory][:user]
end

# The hard part, parse the config XML and update in the right places
#include_recipe 'chef-artifactory::build_config'

# Import the configuration
ruby_block "import Artifactory config" do
  block do
    resp = RestClient.post(
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
    puts resp.code
    puts resp
  end
end

have_admin = false

# Add users
users_dbag = data_bag_item("artifactory", "security")["users"]
if (users_dbag)
  ruby_block "Create Artifactory users" do
    block do
      users_dbag.each do |u| 
        resp = RestClient.put(
          "http://admin:password@localhost:8081/artifactory/api/security/users/#{u['name']}", 
          {
            "name" => u['name'],
            "email" => u['email'],
            "password" => u['password'],
            "admin" => u['admin']
          }.to_json, 
          :content_type => "application/json", :accept => "application/json"
        )
        puts "Added user to Artifactory #{u['name']}"
        puts resp.code
        puts resp

        if u['admin']
          have_admin = true
        end
      end
    end
  end
end
