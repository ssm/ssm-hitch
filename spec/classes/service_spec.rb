require 'spec_helper'

describe 'hitch::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { service_name: 'hitch' } }

      it { is_expected.to compile }
      it { is_expected.to contain_service('hitch') }
    end
  end
end
