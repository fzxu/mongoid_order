require 'rubygems' unless RUBY_VERSION =~ /^(?:1.9.*)$/
require 'test/unit'
require 'test/unit/assertions'
require 'bundler/setup'

require 'mongoid'
require 'mongoid_order'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('mongoid_order_test')
  config.allow_dynamic_fields = false
end
