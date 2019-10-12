require 'spec_helper'

describe 'hitch' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'defaults' do
        it { is_expected.to compile }
        it { is_expected.to contain_exec('hitch::config generate dhparams') }
        it {
          is_expected.to contain_file('/etc/hitch/dhparams.pem')
            .without_content
        }
      end

      context 'with dhparams_content' do
        let(:params) { { dhparams_content: 'BEGIN DH PARAMETERS' } }

        it { is_expected.not_to contain_exec('hitch::config generate dhparams') }
        it {
          is_expected.to contain_file('/etc/hitch/dhparams.pem')
            .with_content(%r{BEGIN DH PARAMETERS})
        }
      end
    end
  end
end
