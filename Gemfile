source :rubygems

group :default do
  # Server requirements (defaults to WEBrick)
  gem 'thin'

  # Project requirements
  gem 'rake'
  gem 'sinatra-flash', :require => 'sinatra/flash'

  # Component requirements
  gem 'bcrypt-ruby', :require => "bcrypt"
  gem 'sass'
  gem 'haml'
  gem 'mongoid'
  gem 'bson_ext', :require => "mongo"
  gem 'mongoid_slug'

  # Random requirements
  gem 'awesome_print'
  gem 'term-ansicolor'

  # Test requirements

  # Padrino Stable Gem
  gem 'padrino', '0.10.5'
end

group :production do
  gem 'newrelic_rpm'
end
# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.5'
# end
