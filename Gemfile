# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.7.4'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

# Gitlab CI gems
gem 'brakeman'
gem 'bundler-audit'
gem 'rubocop', '~> 1.23', require: false
gem 'rubocop-rspec'

gem 'sentry-raven'

gem 'activerecord-session_store'
gem 'bcrypt_pbkdf'
gem 'bootsnap'
gem 'ed25519'
gem 'geocoder', '~> 1.3'
gem 'puma'
gem 'rails', '~> 6.1', '>= 6.1.4'
gem 'responders'
gem 'webpacker'

gem 'gon'
gem 'pg'

gem 'hamlit'
gem 'hamlit-rails'

gem 'draper'
gem 'ransack'
gem 'simple_form'

gem 'bootstrap'
gem 'font-awesome-rails'
gem 'font-awesome-sass'
gem 'sassc'
gem 'sassc-rails'

gem 'bootstrap-will_paginate'
gem 'will_paginate'

gem 'cancancan'
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'devise_invitable', '~> 2.0.0'
gem 'devise_ldap_authenticatable'

gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever'

gem 'devise-security'
gem 'jquery-rails'
gem 'rails_email_validator'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'sqlite3'
end

group :development do
  gem 'epi_deploy', github: 'epigenesys/epi_deploy'

  gem 'listen'
  gem 'web-console'

  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  gem 'annotate'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'webdrivers'

  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
end
