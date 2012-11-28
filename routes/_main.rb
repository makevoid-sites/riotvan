class RiotVan < Sinatra::Base
  get "/" do
    @articles = Collection.get :articoli
    haml :index
  end

  get "/chi_siamo" do
    haml :chi_siamo_page
  end

  get "/shop" do
    haml :shop
  end

  get "/collabs" do
    haml :collabs
  end

  get "/articoli/:article_id" do
    article_id = params[:article_id].split("-")
    article_id = article_id[0] if article_id
    @article = Article.get article_id
    haml :article
  end

  get "/issues/*" do
    haml :read
  end

  get "/workshop" do
    haml :workshop
  end

  get "/collabs/*" do
    haml :collab
  end

  get "/videos" do
    haml :videos
  end

  get "/videos/*" do
    haml :video_page
  end

  get "/event" do
    haml :event
  end

  get "/issues" do
    haml :issues
  end

  get "/events" do
    haml :events
  end

  get "/events/*" do
    haml :event
  end

  # unpublisheds

  get "/argomenti" do
    haml :argomenti
  end

  get "/articles" do
    haml :articles
  end

end
