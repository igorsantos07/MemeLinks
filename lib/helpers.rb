Mail::Message.class_eval do
  include Padrino::Helpers::OutputHelpers
  include Padrino::Helpers::TagHelpers
  include Padrino::Helpers::AssetTagHelpers
  include Padrino::Helpers::FormHelpers
  include Padrino::Helpers::FormatHelpers
  include Padrino::Helpers::RenderHelpers
  include Padrino::Helpers::NumberHelpers
  include Padrino::Helpers::TranslationHelpers
end

def production_config dev_file, prod_config
  if PADRINO_ENV == 'production'
      prod_config
  else
    config_file = "#{PADRINO_ROOT}/config/#{dev_file}.yml"
    if File.exists? config_file
      YAML.load_file(config_file).symbolize_keys.freeze
    else
      logger.error "/config/#{dev_file}.yml is required at this environment"
      nil
    end
  end
end