source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch
gem 'solidus_auth_devise'
gem 'deface'

if ENV['DB'] == 'mysql'
  gem 'mysql2', '~> 0.4.10'
else
  gem 'pg', '~> 0.21'
end

group :test do
  gem 'rails-controller-testing'

  if branch < 'v2.5'
    gem 'factory_bot', '5.1.0'
  else
    gem 'factory_bot', '5.1.0'
  end
end

group :development, :test do
  gem 'pry-rails'
end

gemspec
