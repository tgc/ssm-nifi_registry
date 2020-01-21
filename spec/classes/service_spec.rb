require 'spec_helper'

describe 'nifi_registry::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          install_root: '/test',
          version: '1.0.0',
          user: 'nifi_registry',
        }
      end

      it { is_expected.to compile }
    end
  end
end
