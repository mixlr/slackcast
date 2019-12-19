source 'https://rubygems.org'
ruby File.read('.ruby-version')

gem 'rails',           '~> 5.2'
gem 'puma',            '~> 3.12'
gem 'sass-rails',      '~> 5.0'
gem 'haml-rails',      '~> 1.0'
gem 'uglifier',        '~> 4.1'
gem 'jquery-rails',    '~> 4.3'
gem 'turbolinks',      '~> 5.2'
gem 'jbuilder',        '~> 2.5'
gem 'redis',           '~> 3.0'
gem 'slack-ruby-bot'
gem 'foreman',         '~> 0.85'
gem 'async-websocket', '~> 0.8.0'
gem 'dropbox-sdk-v2',  '= 0.0.3', require: 'dropbox'
gem 'bootsnap',        '~> 1',    require: false
gem "barnes"
gem 'airbrake-ruby'
gem 'dpl'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'dotenv-rails'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'pry'
  gem 'listen'
end

group :test do
  gem 'rspec_junit_formatter', require: false
  gem 'simplecov'
end
