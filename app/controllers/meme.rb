Memelinks.controllers :meme do

  get :image, :map => '/:slug', :priority => :low do
    slug = if params[:slug].is_a? Array then params[:slug][0] else params[:slug] end
    meme = Meme.find_by_slug slug
    if meme
      content_type meme.image_mime
      body meme.image
    else
      logger.error params.inspect
      halt 404, 'Meme not found :('
    end
  end

  get :show, :map => '/meme/:slug' do
    redirect url(:meme, :image, :slug => params[:slug])
  end

end