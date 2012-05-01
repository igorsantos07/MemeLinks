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
  case PADRINO_ENV
    when 'production' then prod_config
    else
      mail_config = "#{PADRINO_ROOT}/config/#{dev_file}.yml"
      if File.exists? mail_config
        YAML.load_file(mail_config).symbolize_keys.freeze
      else
        logger.error "/config/#{dev_file}.yml is required at this environment"
        nil
      end
  end
end