#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'pp'
 
class ShortURL
  def self.expand(short_url)
    # http://longurl.org/api
    connection = Net::HTTP.new('api.longurl.org')
    connection.start do |http|
      headers = {
        'Referer' => '',
        'User-Agent' => ''
      }

      path = "/v2/expand?url=#{URI.encode(short_url)}&format=json"
      response = http.request_get(path, headers)

      data = JSON.parse(response.body)

      if data['messages']
        raise data['messages'][0]['message']
      end

      data['long-url']
    end
  end
end
 
 
redirect = "https://raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install".split("/")
shorten = ShortURL.expand('http://dot.b4b4r07.com').split("/")

exit(1) unless redirect[3..-1].join("/") == shorten[3..-1].join("/")
