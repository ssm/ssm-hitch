require 'spec_helper'

tls_data = gen_test_tls_data
key = tls_data[0].to_s
cert = tls_data[1].to_s

describe 'hitch::domain' do
  let(:title) { 'example.com' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with source parameters' do
        let(:params) do
          {
            'key_source' => '/path/to/key',
            'cert_source' => '/path/to/certificate',
            'cacert_source' => '/path/to/cacertificate',
          }
        end

        it { is_expected.to compile }
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

      context 'with content parameters' do
        let(:params) do
          {
            key_content: key,
            cert_content: cert,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_hitch__domain('example.com') }

        # for the pem file
        it { is_expected.to contain_concat('/etc/hitch/example.com.pem') }
        it { is_expected.not_to contain_concat__fragment('example.com cacert') }
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
