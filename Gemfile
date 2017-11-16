source 'https://rubygems.org'

gem 'berkshelf', '~> 4.0'
gem 'berkshelf-api-client', '~> 2.0'
gem 'chef', '>= 11.18.6'
gem 'stove', '~> 3.2'

group :test do
  gem 'chefspec', '~> 4.2'
  gem 'foodcritic', '~> 4.0'
  gem 'rspec', '~> 3.2'
  gem 'rubocop', '~> 0.27.1'
end

group :integration do
  gem 'kitchen-ec2', '~> 0.10'
  gem 'kitchen-sync'
  gem 'kitchen-vagrant'
  gem 'test-kitchen', '~> 1.4'
end

group :documentation do
  gem 'yard', '~> 0.8'
  gem 'yard-chef'
end
