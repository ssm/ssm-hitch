require 'spec_helper'

describe 'hitch::domain' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:title) { 'example.com' }

        context 'with all content parameters' do
          let(:params) do
            {
              'cacert_content' => '-----BEGIN CERTIFICATE-----',
              'cert_content' => '-----BEGIN CERTIFICATE-----',
              'dhparams_content' => '-----BEGIN DH PARAMETERS-----',
              'key_content' => '-----BEGIN PRIVATE KEY-----',
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

        context 'with all source parameters' do
          let(:params) do
            {
              'cacert_source' => '/tmp/cacert.pem',
              'cert_source' => '/tmp/cert.pem',
              'dhparams_source' => '/tmp/dhparams.pem',
              'key_source' => '/tmp/key.pem',
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

        context 'mandatory parameters' do
          let(:params) do
            {
              'cert_source' => '/tmp/cert.pem',
              'key_source' => '/tmp/key.pem',
            }
          end

          it { is_expected.to compile.with_all_deps }
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
end
