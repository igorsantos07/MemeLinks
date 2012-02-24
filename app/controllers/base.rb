Memelinks.controllers :base do

  get :image, :map => '/:slug', :priority => :low do
    meme = Meme.find_by_slug params[:slug][0]
    if meme
      content_type meme.image_mime
      body meme.image
    else
      halt 404, 'Meme not found :('
    end
  end

  get :index, :map => '/' do
    'Nothing to see here... Yet ;)'
  end
end
