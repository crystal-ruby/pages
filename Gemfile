source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'sass-rails'
gem 'uglifier'
gem "haml-rails"
gem "susy" , "2.2.12"

gem 'high_voltage'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
