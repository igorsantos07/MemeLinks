# -*- encoding : utf-8 -*-
Memelinks.controllers :meme do

  get :index, :map => '/' do
    @memes = Meme.limit(10).tops.active
    render 'meme/index'
  end

  get :all, :map => '/todos' do
    @memes = Meme.tops.active
    render 'meme/index'
  end

  get :image, :map => '/:filename', :priority => :low do
    from_admin = !request.referrer.nil? and request.referrer.include? request.host + '/admin/'
    filename = if params[:filename].is_a? Array then params[:filename][0] else params[:filename] end
    meme = (from_admin)? Meme.find_by_filename(filename) : Meme.active.find_by_filename(filename)

    if meme
      if !params['y'].nil? or request.referer.nil? or (
        !from_admin and #if it doesn't come from admin pages
        !(request.referrer =~ Regexp.new(request.host+"\/?")) and #or from the homepage
        !request.referrer.include? request.host + url(:meme,:all) #or from :all action
      )
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
    @meme = Meme.find_by_slug params[:slug]
    halt 404, 'Meme not found :(' if not @meme
    render 'meme/show'
  end

  get :search, :map => '/search' do
    regexp = Regexp.new params[:q].downcase
    @memes = Meme.active.any_of({:name_lower => regexp}, {:keywords => regexp})

    @message = case @memes.length
      when 0 then '<img src="/images/memes/rage-face.gif" /> Não foi encontrado nenhum meme com essas palavras...'
      when 1 then '<img src="/images/memes/challenge-accepted.png" /> Encontramos um meme!<br />É esse?'
      else "<img src=\"/images/memes/mother-of-god.gif\" /> Encontramos #{@memes.length} memes!<br />Tomara que seja um desses."
    end

    render 'meme/index'
  end

  get :suggest, :map => '/sugira' do
    render 'meme/suggest'
  end

  post :suggest, :map => '/sugira' do
    if !recaptcha_valid?
      logger.error 'Invalid recaptcha'
      render 'meme/suggest'
    end

    @meme = Meme.new
    @meme.name    = params['meme']['name']
    @meme.status  = :pending
    @meme.ip_user_creator = request.ip

    if !params['meme']['image_url'].nil?
      @meme.image_url = params['meme']['image_url']
    elsif !params['meme']['image_file'].nil?
      @meme.image_file = params['meme']['image_file']
    end

    if !@meme.valid?
      errors = ''
      @meme.errors.each {|field,msg| errors += "#{field}: #{msg}; " }
      logger.error errors

      render 'meme/suggest'
    else
      @meme.save
      flash[:notice] = 'Muito obrigado! Sua sugestão foi salva e, se aprovada, entrará para o acervo do site :D'
      redirect '/'
    end
  end

end
