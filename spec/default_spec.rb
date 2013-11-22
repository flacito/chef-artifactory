require 'spec_helper'

describe 'appserv-tomcat::default' do

  let (:chef_run) {
    ChefSpec::Runner.new().converge(described_recipe)
  }

  it 'installs tomcat6' do
    expect(chef_run).to install_package('tomcat6')
  end

  it 'starts tomcat6' do
    expect(chef_run).to start_service('tomcat6')
  end
end
