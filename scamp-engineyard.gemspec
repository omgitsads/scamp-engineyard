# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scamp/engineyard/version"

Gem::Specification.new do |s|
  s.name        = "scamp-engineyard"
  s.version     = Scamp::Engineyard::VERSION
  s.authors     = ["Adam Holt"]
  s.email       = ["me@adamholt.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Deploy your EngineYard application via Scamp}
  s.description = %q{Deploy your EngineYard application via Scamp}

  s.rubyforge_project = "scamp-engineyard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "engineyard", "~>1.4.22"
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
