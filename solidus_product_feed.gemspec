# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_log_viewer/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_product_feed'
  s.version     = SolidusProductFeed::VERSION
  s.summary     = 'Spree extension that provides an RSS feed for products'
  s.description = 'A Spree extension that provides an RSS feed for products, with Google Shopper extensions'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Joshua Nussbaum'
  s.email             = 'joshnuss@gmail.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'solidus_core', ["~> 1.0"]
  s.add_runtime_dependency 'solidus_backend', ["~> 1.0"]

  s.add_development_dependency 'rspec-rails',  '~> 3.4'
  s.add_development_dependency 'sqlite3'
end
