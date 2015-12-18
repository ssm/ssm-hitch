require 'spec_helper_acceptance'

describe 'hitch class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'hitch': }
      hitch::domain { 'example.org':
        key_source  => '/tmp/example.org_key.pem',
        cert_source => '/tmp/example.org_cert.pem',
      }
      hitch::domain { 'example.com':
        key_source  => '/tmp/example.com_key.pem',
        cert_source => '/tmp/example.com_cert.pem',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('hitch') do
      it { is_expected.to be_installed }
    end

    describe service('hitch') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
