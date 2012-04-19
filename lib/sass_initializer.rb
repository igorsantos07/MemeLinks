# -*- encoding : utf-8 -*-
module SassInitializer

  def self.registered app
    # Enables support for SASS template reloading in rack applications.
    # See http://nex-3.com/posts/88-sass-supports-rack for more details.
    # Store SASS files (by default) within 'app/stylesheets'

    folders = case app.to_s.downcase
      when 'memelinks'  then {:template => 'app/stylesheets', :css => 'public/stylesheets'}
      when 'admin'      then {:template => 'admin/stylesheets', :css => 'public/admin/stylesheets'}
    end

    require 'sass/plugin/rack'
    Sass::Plugin.options[:template_location] = Padrino.root folders[:template]
    Sass::Plugin.options[:css_location] = Padrino.root folders[:css]
    Sass::Plugin.options[:style] = :compressed
    app.use Sass::Plugin::Rack
  end
end