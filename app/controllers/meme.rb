Memelinks.controllers :meme do

  get :image, :map => '/:filename', :priority => :low do
    filename = if params[:filename].is_a? Array then params[:filename][0] else params[:filename] end
    meme = Meme.find_by_filename filename
    
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