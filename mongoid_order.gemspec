# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "mongoid_order"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ark Xu"]
  s.email       = ["ark.work@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Make Mongoid documents order-able}
  s.description = %q{An easy way to make Mongoid documents order-able by adding position field}

  s.rubyforge_project = "mongoid_order"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency('mongoid', ['>= 2.0.0.beta.20'])
end
