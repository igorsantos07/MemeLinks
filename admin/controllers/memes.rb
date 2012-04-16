# -*- encoding : utf-8 -*-
Admin.controllers :memes do |admin|

  get :index do
    @memes = Meme.desc :created_at
    @top_memes = Meme.limit(20).tops
    render 'memes/index', :layout => :two_column
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
