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
            'key' => '-----BEGIN PRIVATE KEY-----',
            'cert' => '-----BEGIN CERTIFICATE-----',
            'cacert' => '-----BEGIN CERTIFICATE-----',
            'dhparams' => '-----BEGIN DH PARAMETERS-----'
          }
        end
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_hitch__domain('example.com') }
        it { is_expected.to contain_file('/etc/hitch/example.com.pem') }
        it { is_expected.to contain_concat__fragment('hitch::domain example.com') }
      end
    end
  end
end
