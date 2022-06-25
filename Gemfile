# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'rake', '~> 13.0', '>= 13.0.6'

gem 'activesupport', '~> 7.0', '>= 7.0.3', require: false
gem 'config', '~> 4.0'
gem 'dry-initializer', '~> 3.1', '>= 3.1.1'
gem 'dry-validation', '~> 1.8', '>= 1.8.1'
gem 'fast_jsonapi', '~> 1.5'
gem 'i18n', '~> 1.10'
gem 'pg', '~> 1.3', '>= 1.3.5'
gem 'puma', '~> 5.6', '>= 5.6.4'
gem 'sequel', '~> 5.57'
gem 'sequel_secure_password', '~> 0.2.15'
gem 'sinatra', '~> 2.2', require: 'sinatra/base'
gem 'sinatra-contrib', '~> 2.2'

group :development do
  gem 'rubocop', require: false
end

group :test do
  gem 'database_cleaner-sequel', '~> 2.0', '>= 2.0.2'
  gem 'factory_bot', '~> 6.2', '>= 6.2.1'
  gem 'rack-test', '~> 1.1'
  gem 'rspec', '~> 3.11'
end
