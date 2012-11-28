require_relative "fetcher"

class Collection
  extend Fetcher

  def self.get(name)
    collection = Fiveapi::COLLECTIONS.fetch name.to_sym
    json = fetch "collections/#{collection}/articles/limit/5/offset/0"
    json[:articles].map{ |art| art.symkeys } if json
  end
end