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
    haml name.to_sym, locals: locals
  end

  helpers do
    def location_article_id
      request.path.split("/")[-1].split("-")[0]
    end

    def request_host
      if request.port != 80
        request.host_with_port
      else
        request.host
      end
    end

    MONTHS = %w(_ gennaio febbraio marzo aprile maggio giugno luglio agosto settembre ottobre novembre dicembre)

    def date_formatted
      date.strftime "%d #{month} <span class='year'>%Y</span>"
    end

    def format_date(date, type=:long)
      date = Date.parse date
      month = MONTHS[date.month].capitalize
      date_format = case type
        when :long  then "%d #{month} %Y"
        when :short then "%d/%m/%y"
      end
      date.strftime date_format
    end

    def article_preview(text)
      text = text.gsub /\[picasa_(\d+)\]/, ''
      max_length = 520
      if text.length > max_length
        txt = text.split(/\[(file|image)_(\d+)\]/)
        text = "[file_#{txt[2]}] #{txt[3]}" if txt
        "#{text[0..max_length]}..."
      else
        text
      end
    end
  end
end

require_all "#{path}/routes"
