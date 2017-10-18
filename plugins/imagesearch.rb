# = Cinch Google Image Search plugin
# Searches Google Images and returns the first result.
#
# == Configuration
# Add the following to your bot's configure.do stanza:
#
#   config.plugins.options[Cinch::ImageSearch] = {
#     :google_api_key => "",
#     :search_engine_id => ""
#   }
#
# [google_api_key]
#   Using Google's API Console, create an API key for this plugin. See:
#   https://support.google.com/googleapi/answer/6158862?hl=en
#  
# [search_engine_id]
#   This plugin works by creating a Google Custom Search Engine that searches
#   the entire web, but then filters down to just image results. You will need
#   to add the "Search engine ID" provided by your CSE to the bot config file.
#   See: https://cse.google.com/cse/all
#   
# == Author
# Ross Mulcare (@mulcare)
#
# == Notes
# Thanks to Marvin Gülker (Quintus) for his numerous Cinch plugins that I have
# learned and borrowed from. The above comments/documentation are cribbed from
# his style. See: https://github.com/Quintus/cinch-plugins
#
# == License
# The MIT License (MIT)
# Copyright (c) 2016 Ross Mulcare
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'net/http'
require 'json'

class Cinch::ImageSearch
  include Cinch::Plugin
 
  listen_to :connect, :method => :setup

  def setup(*)
    @google_api_key = config[:google_api_key]
    @search_engine_id = config[:search_engine_id]
    @google_api_url = "https://www.googleapis.com/customsearch/v1?"
  end

  def search(query)
    url = "#{@google_api_url}key=#{@google_api_key}&cx=#{@search_engine_id}&searchType=image&num=3&q=#{query}"
    uri = URI(URI.escape(url))
    response = Net::HTTP.get(uri)
    images = JSON.parse(response)
    @result = images["items"][0]["link"]
  end

  match /gis (.+)/
  def execute(m, query)
    gis = search(query)
    m.reply "#{@result}"
  end

end
