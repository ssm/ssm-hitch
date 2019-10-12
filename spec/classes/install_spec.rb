require 'spec_helper'

describe 'hitch::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { package: 'hitch' } }

      it { is_expected.to compile }
      it { is_expected.to contain_package('hitch') }
    end
  end
end
