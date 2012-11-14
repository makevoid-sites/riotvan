class RiotVan < Sinatra::Base
  get "/" do
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

  get "/articoli/*" do
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
