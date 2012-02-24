Memelinks.controllers :base do

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

  get :index, :map => '/' do
    'Nothing to see here... Yet ;)'
  end

  get :sass, :map => '/stylesheets/:file.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass params[:file]
  end
end