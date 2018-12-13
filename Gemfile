source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch
gem 'solidus_auth_devise'
gem 'deface'

if branch == 'master' || branch >= "v2.0"
  gem 'rails-controller-testing', group: :test
else
  gem "rails", "~> 4.2.7"
  gem "rails_test_params_backport", group: :test
end

gem 'pg', '~> 0.21'
gem 'mysql2', '~> 0.4.10'

if branch < "v2.5"
  gem 'factory_bot', '4.10.0', group: :test
else
  gem 'factory_bot', '> 4.10.0', group: :test
end

group :development, :test do
  gem "pry-rails"
end

gemspec
