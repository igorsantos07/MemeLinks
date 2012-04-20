# -*- encoding : utf-8 -*-
module SassInitializer

  def self.registered app
    # Enables support for SASS template reloading in rack applications.
    # See http://nex-3.com/posts/88-sass-supports-rack for more details.
    # Store SASS files (by default) within 'app/stylesheets'
    require 'sass/plugin/rack'
    Sass::Plugin.options[:template_location] = Padrino.root '/stylesheets'
    Sass::Plugin.options[:css_location] = Padrino.root '/public/stylesheets'
    Sass::Plugin.options[:style] = :compressed
    app.use Sass::Plugin::Rack
  end
end