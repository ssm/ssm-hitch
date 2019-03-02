require 'spec_helper'

describe 'hitch' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'hitch class without any parameters' do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('hitch') }
          it { is_expected.to contain_class('hitch::params') }
          it { is_expected.to contain_class('hitch::install').that_comes_before('hitch::config') }
          it { is_expected.to contain_class('hitch::config') }
          it { is_expected.to contain_class('hitch::service').that_subscribes_to('hitch::config') }

          it { is_expected.to contain_service('hitch') }
          it { is_expected.to contain_package('hitch').with_ensure('present') }

          it { is_expected.to contain_file('/etc/hitch') }
          it { is_expected.to contain_file('/etc/hitch/dhparams.pem') }
          it { is_expected.to contain_concat('/etc/hitch/hitch.conf') }
          it { is_expected.to contain_concat__fragment('hitch::config config') }
          it { is_expected.to contain_exec('hitch::config generate dhparams') }

          context 'osfamily specifics' do
            if facts[:osfamily] == 'RedHat'
              it { is_expected.to contain_package('epel-release') }
            else
              it { is_expected.not_to contain_package('epel-release') }
            end
          end
        end

        context 'hitch class with domains' do
          let(:params) do
            { domains: {
              'example.com' => {
                'key_content' => '-----BEGIN PRIVATE KEY-----',
                'cert_content' => '-----BEGIN CERTIFICATE-----',
                'cacert_content' => '-----BEGIN CERTIFICATE-----',
                'dhparams_content' => '-----BEGIN DH PARAMETERS-----',
              },
            } }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_hitch__domain('example.com') }
          it { is_expected.to contain_file('/etc/hitch/example.com.pem') }
          it { is_expected.to contain_concat__fragment('hitch::domain example.com') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'hitch class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('hitch') }.to raise_error(Puppet::Error, %r{Nexenta not supported}) }
    end
  end
end
