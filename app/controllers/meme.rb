Memelinks.controllers :meme do

  get :index, :map => '/' do
    @memes = Meme.limit(10).tops
    render 'base/index'
  end

  get :image, :map => '/:filename', :priority => :low do
    filename = if params[:filename].is_a? Array then params[:filename][0] else params[:filename] end
    meme = Meme.find_by_filename filename

    if meme
      if request.referer.nil? or !request.referrer.include? request.host+'/admin/'
        meme.inc(:all_views_count, 1)
        meme.inc(:external_count, 1) if !request.referer.nil? and !request.referrer.include? request.host
      end
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