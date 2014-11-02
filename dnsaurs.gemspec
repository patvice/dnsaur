$:.push File.expand_path('../lib', __FILE__)
require 'dnsaurs'

Gem::Specification.new do |s|
  s.name        = 'dnsaurs'
  s.version     = Dnsaurs::VERSION
  s.date        = '2014-10-25'
  s.summary     = 'A simple dns checker/ email corrector'
  s.description = 'A simple hello world gem'
  s.authors     = ['Patrick Vice']
  s.email       = 'patrickgvice@gmail.com'
  s.files       = [`git ls-files`.split(",\n")]
  s.homepage    = 'https://github.com/patvice/dnsaurs'
  s.license     = 'MIT'
  s.require_path = ['lib']
end
