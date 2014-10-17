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

gem_package 'nokogiri' do
  action :install
  options '-- --use-system-libraries'
end

ruby_block "build Artifactory config XML" do
  subscribes :create, "#{node[:artifactory][:import_dir]}/artifactory.config.xml", :immediately
  block do
    require 'nokogiri'

    f = File.open("#{node[:artifactory][:import_dir]}/artifactory.config.xml")
    doc = Nokogiri::XML(f) { |x| x.noblanks }
    f.close

    # Build the SSO settings if there
    if (data_bag_item("artifactory", "security")["httpSsoSettings"])
      http_sso_setting = Nokogiri::XML::Node.new "httpSsoSettings", doc
      doc.at('config').at('security').add_child(http_sso_setting)

      http_sso_proxied = Nokogiri::XML::Node.new "httpSsoProxied", doc
      doc.at('config').at('security').at('httpSsoSettings').add_child(http_sso_proxied)
      http_sso_proxied.content = data_bag_item("artifactory", "security")["httpSsoSettings"]["httpSsoProxied"]

      no_auto_user = Nokogiri::XML::Node.new "noAutoUserCreation", doc
      doc.at('config').at('security').at('httpSsoSettings').add_child(no_auto_user)
      no_auto_user.content = data_bag_item("artifactory", "security")["httpSsoSettings"]["noAutoUserCreation"]

      remote_user_var = Nokogiri::XML::Node.new "remoteUserRequestVariable", doc
      doc.at('config').at('security').at('httpSsoSettings').add_child(remote_user_var)
      remote_user_var.content = data_bag_item("artifactory", "security")["httpSsoSettings"]["remoteUserRequestVariable"]
    end

    # Build the LDAP settings if there
    dbag = data_bag_item("artifactory", "security")["ldapSettings"]
    if (dbag)
      dbag.each do |s| 
        ldap_setting = Nokogiri::XML::Node.new "ldapSetting", doc
        doc.at('config').at('security').at('ldapSettings').add_child(ldap_setting)

        ldap_key = Nokogiri::XML::Node.new "key", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(ldap_key)
        ldap_key.content = s["key"]

        enabled = Nokogiri::XML::Node.new "enabled", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(enabled)
        enabled.content = s["enabled"]

        ldap_url = Nokogiri::XML::Node.new "ldapUrl", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(ldap_url)
        ldap_url.content = s["ldapUrl"]

        search = Nokogiri::XML::Node.new "search", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(search)
        
        search_filter = Nokogiri::XML::Node.new "searchFilter", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(search_filter)
        search_filter.content = s["search"]["searchFilter"]

        search_base = Nokogiri::XML::Node.new "searchBase", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(search_base)
        search_base.content = s["search"]["searchBase"]

        manager_dn = Nokogiri::XML::Node.new "managerDn", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(manager_dn)
        manager_dn.content = s["search"]["managerDn"]

        manager_password = Nokogiri::XML::Node.new "managerPassword", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').at('search').add_child(manager_password)
        manager_password.content = s["search"]["managerPassword"]

        auto_create_user = Nokogiri::XML::Node.new "autoCreateUser", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(auto_create_user)
        auto_create_user.content = s["autoCreateUser"]

        email_attribute = Nokogiri::XML::Node.new "emailAttribute", doc
        doc.at('config').at('security').at('ldapSettings').at('ldapSetting').add_child(email_attribute)
        email_attribute.content = s["emailAttribute"]
      end
    end

    open("#{node[:artifactory][:import_dir]}/artifactory.config.xml", 'w') { |f|
      f.puts doc
    }
  end
end
