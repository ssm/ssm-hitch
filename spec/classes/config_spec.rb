require 'spec_helper'

describe 'hitch::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          config_root: '/etc/hitch',
          config_file: '/etc/hitch/hitch.conf',
          dhparams_file: '/etc/hitch/dhparams.pem',
          purge_config_root: true,
          file_owner: 'root',
          user: 'hitch',
          group: 'hitch',
          dhparams_content: :undef,
          write_proxy_v2: 'off',
          frontend: '[*]:443',
          backend: '[::1]:80',
          ciphers: 'MODERN',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/hitch') }

      it { is_expected.to contain_concat('/etc/hitch/hitch.conf') }
      it { is_expected.to contain_concat__fragment('hitch::config config') }

      it { is_expected.to contain_file('/etc/hitch/dhparams.pem') }
      it { is_expected.to contain_exec('hitch::config generate dhparams') }
    end
  end
end
