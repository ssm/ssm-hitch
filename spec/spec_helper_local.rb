require 'openssl'

def gen_test_tls_data
  subject = '/CN=test'

  key  = OpenSSL::PKey::RSA.generate(1024)
  cert = OpenSSL::X509::Certificate.new

  cert.subject = OpenSSL::X509::Name.parse(subject)
  cert.not_before = Time.now
  cert.not_after = Time.now + 3600
  cert.public_key = key.public_key
  cert.serial = 0x01
  cert.version = 3

  ef = OpenSSL::X509::ExtensionFactory.new
  ef.subject_certificate = cert
  ef.issuer_certificate = cert

  cert.extensions = [
    ef.create_extension('basicConstraints', 'CA:TRUE', true),
    ef.create_extension('subjectKeyIdentifier', 'hash'),
  ]

  cert.add_extension ef.create_extension('authorityKeyIdentifier',
                                         'keyid:always,issuer:always')

  cert.sign key, OpenSSL::Digest::SHA256.new

  [key, cert]
end
