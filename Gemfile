source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 6.1.1'
gem 'mysql2', '~> 0.5'
gem 'puma', '~> 5.0'

# Use Active Model has_secure_password
gem 'bcrypt'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# implement auth with JWT
gem 'jwt'

# implement authorization
gem 'pundit'

# seriaization & json_api logic
gem 'jsonapi.rb'

# filtering & sorting
gem 'ransack'

gem 'rswag-api'
gem 'rswag-ui'

# Httparty hard!
gem 'httparty'

# hange audits
gem "audited", "~> 5.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.2'
  gem 'rswag-specs'

  # Mock webhook
  gem "webmock"
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
