$:.push File.expand_path('../lib', __FILE__)
require 'dnsaur'

Gem::Specification.new do |s|
  s.name          = 'dnsaur'
  s.version       = Dnsaur::VERSION
  s.date          = '2014-10-25'
  s.authors       = ['Patrick Vice']
  s.email         = ['patrickgvice@gmail.com']
  s.summary       = 'A simple dns checker/ mistyped email suggester'
  s.description   = <<-EOF
   Dnsaur is a simple DNS checker / email corrector for ruby. This gem does three
   things; when a user misspells a domain, it suggests the right spelling, it
   provide simple reverse DNS helper methods to help verifiy these emails, and
   splits emails into three parts(top level domain, domain, address).
  EOF
  s.homepage      = 'https://github.com/patvice/dnsaur'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
