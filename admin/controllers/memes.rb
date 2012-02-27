# -*- encoding : utf-8 -*-
Admin.controllers :memes do |admin|

  def admin.set_meme_image meme, file, url
    if !file.nil?
      meme.image_mime  = file[:head].match(/Content-Type: ([\w\/-_]*)/i)[1]
      meme.image       = file[:tempfile].read
    elsif !url.empty?
      require 'net/http'
      image = Net::HTTP.get_response URI(url)
      if image.is_a? Net::HTTPSuccess
        meme.image_mime = image.get_fields('content-type')[0]
        meme.image      = image.body
      end
    end
  end

  get :index do
    @memes = Meme.asc :name_lower
    @top_memes = Meme.limit(20).tops
    render 'memes/index', :layout => :two_column
  end

  get :new do
    @meme = Meme.new
    render 'memes/new'
  end

  post :create do
    @meme = Meme.new
    @meme.creator         = current_account
    @meme.name            = params[:meme]['name']
    @meme.keywords_string = params[:meme]['keywords_string']

    admin.set_meme_image @meme, params[:meme]['image_file'], params[:meme]['image_url']

    if @meme.save
      flash[:notice] = 'Meme was successfully created.'
      redirect url(:memes, :edit, :id => @meme.id)
    else
      render 'memes/new'
    end
  end

  get :edit, :with => :id do
    @meme = Meme.find(params[:id])
    render 'memes/edit'
  end

  put :update, :with => :id do
    @meme = Meme.find params[:id]
    @meme.updater         = current_account
    @meme.name            = params[:meme]['name']
    @meme.keywords_string = params[:meme]['keywords_string']

    admin.set_meme_image @meme, params[:meme]['image_file'], params[:meme]['image_url']

    if @meme.update
      flash[:notice] = 'Meme was successfully updated.'
      redirect url(:memes, :edit, :id => @meme.id)
    else
      render 'memes/edit'
    end
  end

  delete :destroy, :with => :id do
    meme = Meme.find(params[:id])
    if meme.destroy
      flash[:notice] = 'Meme was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Meme!'
    end
    redirect url(:memes, :index)
  end
end
