#
# Cookbook Name:: artifactory
# Recipe:: build_config
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

require 'rubygems'
require 'nokogiri'

ruby_block "build Artifactory config XML" do

  f = File.open(node[:artifactory][:import_dir]}/artifactory.config.xml)
  doc = Nokogiri::XML(f) { |x| x.noblanks }
  f.close

  # Build the LDAP settings if there
  if (data_bag_item("artifactory", "ldap") not nil)
    ldap_setting = Nokogiri::XML::Node.new "ldapSetting", doc
    doc.at('config').at('security').at('ldapSettings').add_child(ldap_setting)

    ldap_key = Nokogiri::XML::Node.new "key", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(ldap_key)
    ldap_key.content = data_bag_item("artifactory", "ldap")["key"]

    enabled = Nokogiri::XML::Node.new "enabled", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(enabled)
    enabled.content = data_bag_item("artifactory", "ldap")["enabled"]

    ldap_url = Nokogiri::XML::Node.new "ldapUrl", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(ldap_url)
    ldap_url.content = data_bag_item("artifactory", "ldap")["ldapUrl"]

    search = Nokogiri::XML::Node.new "search", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(search)
    
    search_filter = Nokogiri::XML::Node.new "searchFilter", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(search_filter)
    search_filter.content = data_bag_item("artifactory", "ldap")["search"]["searchFilter"]

    search_base = Nokogiri::XML::Node.new "searchBase", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(search_base)
    search_base.content = data_bag_item("artifactory", "ldap")["search"]["searchBase"]

    manager_dn = Nokogiri::XML::Node.new "managerDn", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(manager_dn)
    manager_dn.content = data_bag_item("artifactory", "ldap")["search"]["managerDn"]

    manager_password = Nokogiri::XML::Node.new "managerPassword", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(manager_password)
    manager_password.content = data_bag_item("artifactory", "ldap")["search"]["managerPassword"]

    auto_create_user = Nokogiri::XML::Node.new "autoCreateUser", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(auto_create_user)
    auto_create_user.content = data_bag_item("artifactory", "ldap")["autoCreateUser"]

    email_attribute = Nokogiri::XML::Node.new "emailAttribute", doc
    doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(email_attribute)
    email_attribute.content = data_bag_item("artifactory", "ldap")["emailAttribute"]
  end

  open(node[:artifactory][:import_dir]}/artifactory.config.xml, 'w') { |f|
    f.puts doc
  }

end
