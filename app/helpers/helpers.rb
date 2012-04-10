# -*- encoding : utf-8 -*-
Memelinks.helpers do

  def log_common_request_data extra_data = {}, level = :warn
      logged_info = {
        :media_type => request.media_type,
        :host => request.host,
        :form_data => request.form_data?,
        :referrer => request.referrer,
        :ua => request.user_agent,
        :xhr => request.xhr?,
        :url => request.url,
        :ip => request.ip,
        :forwarded => request.forwarded?,
        :methods => {
          :get => request.get?,
          :post => request.post?,
          :put => request.put?,
          :delete => request.delete?,
          :head => request.head?
        }
      }

      logger.push '[Image requested] '+extra_data.inspect+logged_info.inspect, level
  end

  def emoticon emote
    image_tag "/images/emoticons/#{emote}.gif"
  end

end