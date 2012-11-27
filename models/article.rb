require 'net/http'

class Article
  def self.get(id)
    uri = URI.parse "http://#{FIVEAPI_HOST}/articles/#{id}"
    article = Net::HTTP.get_response uri
    if article.code == "200"
      json = JSON.parse article.body
      json = Hash[json.map{|(k,v)| [k.to_sym,v]}]
      json unless json[:error]
    end
  end
end