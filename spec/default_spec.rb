require 'spec_helper'

describe 'appserv-artifactory::default' do

  let (:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['platform'] = 'redhat'
      node.set['version'] = '6.3'
    end.converge(described_recipe)
  end

  it 'gets artifactory' do
    expect(chef_run).to create_remote_file('/tmp/artifactory-3.1.1.1.rpm').with(
      {
        :source => "http://172.16.18.1/devops/artifactory-3.1.1.1.rpm"
      });
  end

  it 'installs artifactory' do
    expect(chef_run).to install_rpm_package('artifactory')
  end

  it 'starts artifactory' do
    expect(chef_run).to start_service('artifactory')
  end
end
