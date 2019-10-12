require 'spec_helper'

describe 'hitch::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { manage_repo: true, package: 'hitch' } }

      it { is_expected.to compile }
      it { is_expected.to contain_package('hitch') }

      it {
        case facts[:os]['family']
        when 'RedHat'
          is_expected.to contain_package('epel-release')
        else
          is_expected.not_to contain_package('epel-release')
        end
      }
    end
  end
end
