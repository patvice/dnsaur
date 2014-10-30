$:.push File.expand_path('../lib', __FILE__)
require 'dnsaurs'

Gem::Specification.new do |s|
  s.name        = 'dns-checker'
  s.version     = Dnsaurs::VERSION
  s.date        = '2014-10-25'
  s.summary     = 'A simple dns-checker that will give you spelling sujections if dns comes back fails'
  s.description = 'A simple hello world gem'
  s.authors     = ['Patrick Vice']
  s.email       = 'patrickgvice@gmail.com'
  s.files       = [`git ls-files`.split(",\n")]
  s.homepage    = 'https://github.com/patvice/dns-checker'
  s.license     = 'MIT'
  s.require_path = ['lib']
end
