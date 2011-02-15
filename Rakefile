require 'rake/testtask'
require 'rake/gempackagetask'

require 'bundler'
Bundler::GemHelper.install_tasks


task :default => 'test'

Rake::TestTask.new(:test) do |t|
  t.libs << '.' << 'lib' << 'test'
  t.pattern = 'test/lib/**/*_test.rb'
  t.verbose = false
end

gemspec = eval(File.read('mongoid_order.gemspec'))
Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end

desc "build the gem and release it to rubygems.org"
task :release => :gem do
  sh "gem push pkg/mongoid-order-#{gemspec.version}.gem"
end
