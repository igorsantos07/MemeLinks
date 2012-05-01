# -*- encoding : utf-8 -*-
Admin.controllers :memes do |admin|

  before do
    @pending_conditions = {:status => Meme::Status[:pending]}
    @total_pending = Meme.where(@pending_conditions).count
  end

  before :index, :pending do
    begin # paging config
      @current_page = (params[:page] || 1).to_i
      @page_size = 15
    end
  end

  get :index do
    @total_memes = Meme.count # paging
    @memes = Meme
      .desc(:created_at)
      .skip(@page_size * (@current_page - 1))
      .limit(@page_size)
    @top_memes = Meme.limit(20).tops

    render 'memes/index', :layout => :two_column
  end

  get :pending do
    @total_memes = @total_pending # paging
    @memes = Meme
      .where(@pending_conditions)
      .desc(:created_at)
      .skip(@page_size * (@current_page - 1))
      .limit(@page_size)

    render 'memes/index'
  end

  get :new do
    @meme = Meme.new
    render 'memes/new'
  end

  post :create do
    @meme = Meme.new params[:meme]
    @meme.creator = current_account

    if @meme.save
      flash[:notice] = 'Meme was successfully created.'
      redirect url(:memes, :edit, :id => @meme.id)
    else
      render 'memes/new'
    end
  end

  get :edit, :with => :id do
    @meme = Meme.find(params[:id])
    render 'memes/edit', :layout => :two_column
  end

  put :update, :with => :id do
    @meme = Meme.find params[:id]
    @meme.attributes = params[:meme]
    @meme.updater = current_account

    if @meme.save
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
end
