# encoding: utf-8

class RiotVan < Sinatra::Base

  def redirect_without_www
    redirect "http://#{request.host.sub(/^www./, '')}#{request.path}" if request.host =~ /^www./
  end

  before do
    redirect_without_www
  end

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

  get "/issues" do
    haml :issues
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
  
  get "/storytelling" do
    haml :videos
  end

  get "/storytelling/*" do
    haml :video_page
  end

  get "/event" do
    haml :event
  end


  get "/events" do
    haml :events
  end

  get "/map" do
    haml :map
  end

  get "/events/*" do
    haml :event
  end

  get "/guerrilla_spam/libro" do
    haml :guerrilla_spam_libro
  end

  get "/riot_house" do
    haml :riot_house
  end
  
  get "/lista_distribuzione" do
    haml :lista_distribuzione
  end
  
  get "/soluzioni_cruciverba" do
    haml :soluzioni_cruciverba
  end

  # post "/mail/guerrilla_spam" do
  #   mail = params[:mail]
  #   message = Mail.new do
  #           to MAIN_EMAIL
  #         from 'm4kevoid@gmail.com'
  #     reply_to mail["from"]
  #      subject "RV.net: Libro SPAM <#{mail["from"]}>"
  #         body "Vorrei il libro di Guerrilla SPAM, rispondetemi con questo messaggio:
  #
  #         Ciao,
  #
  #         vieni pure a ritiare la tua copia del libro \"Tutto ciò che sai è falso\" di Guerrilla SPAM in sede RiotVan: http://goo.gl/maps/4IUx0 (Via Santa Reparata 40/r - Firenze)
  #
  #         Per sapere se siamo aperti controlla questa pagina:
  #         http://riotvan.net/riot_house
  #
  #         A presto!
  #         "
  #   end
  #   message.deliver
  #   haml :email_success
  # end

  # unpublisheds

  get "/argomenti" do
    haml :argomenti
  end

  get "/articles" do
    haml :articles
  end

end
