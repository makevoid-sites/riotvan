path = File.expand_path '../', __FILE__
PATH = path

require "#{path}/config/env.rb"

class RiotVan < Sinatra::Base
  include Voidtools::Sinatra::ViewHelpers

  set :root, PATH
  set :public_folder, PATH

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
end

require_all "#{path}/routes"
