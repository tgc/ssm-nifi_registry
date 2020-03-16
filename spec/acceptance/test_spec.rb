require 'spec_helper_acceptance'

pp_defaults = <<-PUPPETCODE
  class { 'java': }
  class { 'nifi_registry': }

  Package['java'] -> Service['nifi-registry.service']
PUPPETCODE

describe 'NiFi Registry' do
  idempotent_apply(pp_defaults)

  describe file('/opt/nifi-registry') do
    it { is_expected.to be_directory }
  end

  describe file('/opt/nifi-registry/current/conf/nifi-registry.properties') do
    it { is_expected.to be_file }
  end

  describe service('nifi-registry.service') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
