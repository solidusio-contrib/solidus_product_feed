source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch
gem 'solidus_auth_devise'
gem 'deface'

if branch == 'master' || branch >= "v2.3"
  gem 'rails', '~> 5.1.0' # hack for broken bundler dependency resolution
  gem 'rails-controller-testing', group: :test
elsif branch >= "v2.0"
  gem 'rails', '~> 5.0.0' # hack for broken bundler dependency resolution
  gem 'rails-controller-testing', group: :test
else
  gem "rails", "~> 4.2.7"
  gem "rails_test_params_backport", group: :test
end

gem 'pg', '~> 0.21'
gem 'mysql2'

group :development, :test do
  gem "pry-rails"
end

gemspec
