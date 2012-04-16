# -*- encoding : utf-8 -*-
class Memelinks < Padrino::Application
  register SassApp
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

######################## VARIOUS SETTINGS ########################
  enable :sessions
  layout :main
  set :haml, :format => :html5

######################## SASS ROUTE ########################
  get :sass, :map => '/stylesheets/:file.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass params[:file]
  end

######################## MAIL SETTINGS ########################
  mail_settings = production_config :mail, {
    :user_name => ENV['EMAIL_USERNAME'],
    :password => ENV['EMAIL_PASSWORD']
  }
  set :delivery_method, :smtp => {
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :user_name            => mail_settings[:user_name],
    :password             => mail_settings[:password],
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
  set :mailer_defaults, :from => 'no-reply@memelinks.com'
  set :mailer_defaults, :to => 'igor.santos@memelinks.com'

######################## RECAPTCHA SETTINGS ########################
  recaptcha_config = production_config :recaptcha, {
    :public_key  => ENV['RECAPTCHA_PUBLIC'],
    :private_key => ENV['RECAPTCHA_SECRET']
  }
  use Rack::Recaptcha, recaptcha_config
  helpers Rack::Recaptcha::Helpers


######################## DEFAULT SHIT ########################
  ##
  # Caching support
  #
  # register Padrino::Cache
  # enable :caching
  #
  # You can customize caching store engines:
  #
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
  #   set :cache, Padrino::Cache::Store::Memory.new(50)
  #   set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
  #

  ##
  # Application configuration options
  #
  # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
  # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
  # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
  # set :public_folder, "foo/bar" # Location for static assets (default root/public)
  # set :reload, false            # Reload application files (default in development)
  # set :default_builder, "foo"   # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"       # Set path for I18n translations (default your_app/locales)
  # disable :sessions             # Disabled sessions by default (enable if needed)
  # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
  #

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #
end
