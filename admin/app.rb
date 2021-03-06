# -*- encoding : utf-8 -*-
class Admin < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

######################## VARIOUS SETTINGS ########################
  enable  :sessions
  disable :store_location
  layout  :one_column
  set :login_page, "/admin/sessions/new"
  set :haml, :format => :html5

######################## SASS ROUTE ########################
  get :sass, :map => '/stylesheets/:file.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass params[:file]
  end

######################## ACCESS CONTROL ########################
  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :admin do |role|
    role.project_module :memes, "/memes"
    role.project_module :accounts, "/accounts"
  end

######################## GETCLICKY ########################
  getclicky_config = production_config :getclicky, {
    :sitekey  => ENV['GETCLICKY_SITEKEY'],
    :admin_sitekey  => ENV['GETCLICKY_ADMIN_SITEKEY']
  }
  Getclicky.configure do |config|
    config.site_id = 66546313
    config.sitekey = getclicky_config[:sitekey]
    config.admin_sitekey = getclicky_config[:admin_sitekey]
  end


######################## DEFAULT SHIT ########################
  ##
  # Application configuration options
  #
  # set :raise_errors, true        # Raise exceptions (will stop application) (default for test)
  # set :dump_errors, true         # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true     # Shows a stack trace in browser (default for development)
  # set :logging, true             # Logging in STDOUT for development and file for production (default only for development)
  # set :public_folder, "foo/bar"  # Location for static assets (default root/public)
  # set :reload, false             # Reload application files (default in development)
  # set :default_builder, "foo"    # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"        # Set path for I18n translations (default your_app/locales)
  # disable :sessions              # Disabled sessions by default (enable if needed)
  # disable :flash                 # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
  # layout :my_layout              # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

end
