# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'haml-rails', '~>2.0'
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'pry-byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-mocks', '~> 3.10'
  gem 'rspec-rails', '~> 5.0'
end

group :development do
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rubocop-rails', '~> 2.11'
  gem 'rubocop-rspec', '~> 2.4'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.21'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
