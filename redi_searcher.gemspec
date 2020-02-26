# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redi_searcher/version"

Gem::Specification.new do |s|
  s.name        = "redi_searcher"
  s.version     = RediSearcher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patricio Beckmann"]
  s.email       = ["pato.beckmann@gmail.com"]
  s.homepage    = "https://github.com/Ticketplus/redi_searcher"
  s.summary     = %q{RediSearch ruby client}
  s.description = %q{''}
  s.required_ruby_version = '>= 2.3'
  s.license     = 'MIT'

  s.add_dependency "redis", ">= 3.0"

  s.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(spec/)}) }

  s.require_paths = ["lib"]
end
