# -*- encoding : utf-8 -*-
Admin.controllers :memes do |admin|

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
    p @meme.status
    @meme.updater         = current_account
    @meme.name            = params[:meme]['name']
    @meme.status          = params[:meme]['status']
    @meme.keywords_string = params[:meme]['keywords_string']
    p @meme.status

    if !params[:meme]['image_url'].nil?
      @meme.image_url = params[:meme]['image_url']
    elsif !params[:meme]['image_file'].nil?
      @meme.image_file = params[:meme]['image_file']
    end

    if @meme.update
      flash[:notice] = 'Meme was successfully updated.'
      redirect url(:memes, :index)
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

  get :fix_status do
    memes = Meme.all
    memes.each do |meme|
      meme.update_attribute :status, Meme::Status[:active] if meme.status.nil?
    end

    redirect url :memes, :index
  end
end