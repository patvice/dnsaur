$:.push File.expand_path('../lib', __FILE__)
require 'dnsaur'

Gem::Specification.new do |s|
  s.name          = 'dnsaur'
  s.version       = Dnsaur::VERSION
  s.date          = '2014-10-25'
  s.authors       = ['Patrick Vice']
  s.email         = ['patrickgvice@gmail.com']
  s.summary       = 'A simple dns checker/ mistyped email suggester'
  s.description   = 'A simple dns checker and email '
  s.homepage      = 'https://github.com/pavice/dnsaur'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
