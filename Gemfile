source 'https://rubygems.org'

gemspec

gem 'coveralls', require: false

group :development, :test do
  gem 'pry-debugger', platforms: :mri_19
  gem 'pry-byebug', platforms: :mri_21
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
end

group :test do
  gem 'rspec', '~> 2.14.0'
  gem 'simplecov', '~> 0.9'
  gem 'fakeweb', '~> 1.2.8'
end
