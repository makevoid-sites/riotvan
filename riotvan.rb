path = File.expand_path '../', __FILE__
PATH = path

require "#{path}/config/env.rb"

class RiotVan < Sinatra::Base
  include Voidtools::Sinatra::ViewHelpers

  # partial :comment, { comment: "blah" }
  # partial :comment, comment

  def partial(name, value)
    locals = if value.is_a? Hash
      value
    else
      hash = {}; hash[name] = value
      hash
    end
    haml "_#{name}".to_sym, locals: locals
  end

  helpers do
    def location_article_id
      request.path.split("/")[-1].split("-")[0]
    end

    def render_article(article)
      haml :articoli_article, locals: {article: article}
    end

    def request_host
      if request.port != 80
        request.host_with_port
      else
        request.host
      end
    end
  end
end

require_all "#{path}/routes"
