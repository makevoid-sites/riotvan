require 'net/http'

module Fetcher
  def fetch(url)
    response = request url
    if response.code == "200"
      json = JSON.parse response.body
      json = json.symkeys
      json unless json[:error]
    end
  end

  def request(url)
    uri = URI.parse "http://#{FIVEAPI_HOST}/#{url}"
    Net::HTTP.get_response uri
  end
end