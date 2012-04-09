# -*- encoding : utf-8 -*-
Memelinks.mailer :users do

  email :suggested_meme do |meme, request|
    from 'suggestions@memelinks.com'
    subject "Nova Sugestão no MemeLinks - #{meme.name}"
    locals :meme => meme, :url => 'http://'+request.host
    html_part render('users/suggested_meme')
    add_file :filename => meme.filename, :content => meme.image
  end

end