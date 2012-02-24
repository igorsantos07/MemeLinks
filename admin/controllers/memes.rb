Admin.controllers :memes do

  get :index do
    @memes = Meme.all
    render 'memes/index'
  end

  get :new do
    @meme = Meme.new
    render 'memes/new'
  end

  post :create do
    @meme = Meme.new
    @meme.name = params[:meme]['name']
    @meme.image_mime = params[:meme]['image'][:head].match(/Content-Type: ([\w\/-_]*)/i)[1]
    @meme.image = params[:meme]['image'][:tempfile].read
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
    render 'memes/edit'
  end

  put :update, :with => :id do
    @meme = Meme.find(params[:id])
    if @meme.update_attributes(params[:meme])
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
