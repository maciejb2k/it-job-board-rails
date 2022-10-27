# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/ac>tive_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Authentication and authorization, tokens
gem 'devise', '~> 4.8.1'
gem 'devise_token_auth', '~> 1.2.1'

# JSON schema validation
gem 'json-schema', '~> 2.8.1'

# Easy JSON validations in models
gem 'activerecord_json_validator', '~> 2.1.1'

# Use Active Storage variants
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1.1'

# Serializers for API
gem 'active_model_serializers', '~> 0.10.0'

# Mapping controller parameters to scopes in resources
gem 'has_scope', '~> 0.8.0'

# Clearing database
gem 'database_cleaner', '~> 2.0.1'

# Pagination
gem 'pagy', '~> 5.10'

# Allow certain values in strong parameters
gem 'allowable', '~> 1.1.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'byebug', '~> 11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker', '~> 2.23.0'
  gem 'rspec-rails', '5.1.2'
  gem 'rubocop', '~> 1.36.0', require: false
  gem 'rubocop-performance', '~> 1.15.0', require: false
  gem 'rubocop-rails', '~> 2.16.1', require: false
  gem 'rubocop-rspec', '~> 2.13.2', require: false
  gem 'shoulda-matchers', '~> 5.0'
  gem "test-prof", "~> 1.0"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
