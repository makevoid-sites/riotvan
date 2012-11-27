path = File.expand_path '../../', __FILE__
APP = "riotvan"

require "bundler/setup"
Bundler.require :default
module Utils
  def require_all(path)
    Dir.glob("#{path}/**/*.rb") do |model|
      require model
    end
  end
end
include Utils

FIVEAPI_HOST = if ENV['RACK_ENV'] == "development"
  "localhost:3000"
else
  "fiveapi.com"
end

env = ENV["RACK_ENV"] || "development"
# DataMapper.setup :default, "mysql://localhost/riotvan_#{env}"
require_all "#{path}/models"
# DataMapper.finalize