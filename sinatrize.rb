# Sinatrize

# usage:
#
# mkdir -p yourapp
# cd yourapp
# wget https://raw.github.com/gist/2385559/sinatrize.rb
# ruby  sinatrize.rb
# rm -f sinatrize.rb
# bundle
# foreman start


module Capitalize
  def capitalize
    str = self.class? String ? self : self.to_s
    str[0].upcase + str[1..-1]
  end

  def camelcase
    self.split("_").map(&:capitalize).join('')
  end
end

class Pathname
  include Capitalize
end

class String
  include Capitalize
end

## environment

path = File.expand_path ".", __FILE__
require 'pathname'
dirname = Pathname.new(path).dirname.basename
app_name = dirname.to_s
# puts app_name

## configs

dirs = ["config", "coffee", "views", "public", "routes", "sass", "public/css"]

files = [
  { path: "Gemfile",
    contents: <<-CONT
source :rubygems

gem "sinatra"
gem "json"

# gem "dm-core"
# gem "dm-mysql-adapter"
# gem "dm-migrations"

gem "haml"
gem "sass"

group :development do
  gem "foreman"
  gem "rerun"
  gem "guard"
  gem "guard-sass",         require: false
  gem "guard-coffeescript", require: false
  gem "guard-livereload",   require: false
  # gem "growl"
end

group :test do
  # gem "rspec-core"
  # gem "rspec-mocks"
  # gem "rspec-expectations"
  # gem "rack-test"
end

gem "voidtools"
CONT
  },
  { path: "Procfile",
    contents: <<-CONT
srv: bundle exec rerun --pattern "**/*.{rb,erb,ru}" -- bundle exec rackup -p 3000 -o 0.0.0.0
guard: bundle exec guard
CONT
  },
  { path: "config.ru",
    contents: <<-CONT
path = File.expand_path '../', __FILE__

require "\#{path}/#{app_name}"
run #{app_name.camelcase}
CONT
  },
  { path: "#{app_name}.rb",
    contents: <<-CONT
path = File.expand_path '../', __FILE__

require "\#{path}/config/env.rb"

class #{app_name.camelcase} < Sinatra::Base
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
    haml "_\#{name}".to_sym, locals: locals
  end
end

require_all "\#{path}/routes"
CONT
  },
  { path: "config/env.rb",
    contents: <<-CONT
path = File.expand_path '../../', __FILE__
APP = "#{app_name}"

require "bundler/setup"
Bundler.require :default
module Utils
  def require_all(path)
    Dir.glob("\#{path}/**/*.rb") do |model|
      require model
    end
  end
end
include Utils

env = ENV["RACK_ENV"] || "development"
# DataMapper.setup :default, "mysql://localhost/#{app_name}_\#{env}"
require_all "\#{path}/models"
# DataMapper.finalize

CONT
  },
  { path: "routes/_main.rb",
    contents: <<-CONT
class #{app_name.camelcase} < Sinatra::Base
  get "/" do
    haml :index
  end
end
CONT
  },
  { path: "views/index.haml",
    contents: <<-CONT
Hello world!
CONT
  },
  { path: "views/layout.haml",
    contents: <<-CONT
%html
  %head
    %title #{app_name.camelcase}
    %link{ rel: "stylesheet", href: "/css/main.css" }
  %body
    #container
      %header
        %h1 #{app_name.camelcase}
      %nav
      %section.content= yield
    %script{ type: "text/javascript", src: "/js/app.js" }
CONT
  },
  { path: "Guardfile",
    contents: <<-CONT
guard 'sass', input: 'sass', output: 'public/css'
guard 'coffeescript', input: 'coffee', output: "public/js"
guard 'livereload' do
  watch(%r{views/.+\.(erb|haml|slim|md|markdown)})
  watch(%r{public/css/.+\.css})
  watch(%r{public/js/.+\.js})
end
CONT
  },
  { path: "sass/main.sass",
    contents: <<-CONT
body
  background: #EEE
CONT
  },
  { path: "coffee/app.coffee",
    contents: <<-CONT
console.log "hello coffee!"
CONT
  },
]

## code

def create_directories(dirs)
  dirs.each do |dir|
    `mkdir -p #{dir}`
  end
end

create_directories dirs

files.each{ |file| file[:contents].strip! }

files.each do |file|
  File.open(file[:path], "w") do |f|
    f.write file[:contents]
  end
end

# To add:

## scripts:

# create database: mysql -u root -e "CREATE DATABASE #{app_name}_development;"

# run seeds: ruby config/seeds.rb

# auto migrate: ruby -e 'DataMapper.auto_migrate!' -r "./config/env"