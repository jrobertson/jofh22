Gem::Specification.new do |s|
  s.name = 'jofh22'
  s.version = '0.2.0'
  s.summary = 'Jobs Online form helper 2022 (Experimental)'
  s.authors = ['James Robertson']
  s.files = Dir['lib/jofh22.rb', 'data/nhs_scot.yaml']
  s.add_runtime_dependency('ferrumwizard', '~> 0.3', '>=0.3.4')
  s.signing_key = '../privatekeys/jofh22.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/jofh22'
end
