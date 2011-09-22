# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tdop_math/version"

Gem::Specification.new do |s|
  s.name        = "tdop_math"
  s.version     = TdopMath::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Navin Keswani"]
  s.email       = ["navin@novemberkilo.com"]
  s.homepage    = "http://github.com/novemberkilo/tdop_math"
  s.summary     = %q{A top down operator precedence parser for mathematical expressions}
  s.description = %q{A top down operator precedence parser for mathematical expressions}

  s.rubyforge_project = "tdop_math"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("smithereen")
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rcov'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'rspec', ['~> 2.0']
  s.add_development_dependency 'cucumber'

end
