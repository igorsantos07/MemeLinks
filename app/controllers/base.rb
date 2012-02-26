Memelinks.controllers :base do
  get :index, :map => '/' do
    @memes = Meme.limit(10).tops
    render 'base/index'
  end

  get :sass, :map => '/stylesheets/:file.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass params[:file]
  end
end