require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'hitch')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      ['example.com', 'example.org'].each do |domain|
        on host, 'openssl req -newkey rsa:2048 -sha256 -keyout /tmp/%s_key.pem -nodes -x509 -days 365 -out /tmp/%s_cert.pem -subj "/CN=%s"' % [ domain, domain, domain ]
      end
      on host, 'ls -l /tmp'
    end
  end
end
