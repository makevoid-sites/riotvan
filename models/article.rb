require_relative "fetcher"

class Article
  extend Fetcher

  def self.get(id)
    fetch "articles/#{id}"
  end
end