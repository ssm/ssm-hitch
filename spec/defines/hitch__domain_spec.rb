require 'spec_helper'

describe 'hitch::domain' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:title) { 'example.com' }
        let(:params) do
          {
            'cacert' => '-----BEGIN CERTIFICATE-----',
            'cert' => '-----BEGIN CERTIFICATE-----',
            'key' => '-----BEGIN PRIVATE KEY-----',
            'dhparams' => '-----BEGIN DH PARAMETERS-----'
          }
        end
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_hitch__domain('example.com') }

        # for the pem file
        it { is_expected.to contain_concat('/etc/hitch/example.com.pem') }
        it { is_expected.to contain_concat__fragment('example.com cacert') }
        it { is_expected.to contain_concat__fragment('example.com cert') }
        it { is_expected.to contain_concat__fragment('example.com key') }
        it { is_expected.to contain_concat__fragment('example.com dhparams') }

        # for the config file
        it { is_expected.to contain_concat('/etc/hitch/hitch.conf') }
        it { is_expected.to contain_concat__fragment('hitch::domain example.com') }
      end
    end
  end
end
