load 'hats.rb'

require 'nokogiri'
require 'pry'

response = faraday.get 'market/search/render/', query: 'appid:440 unusual', search_descriptions: 0, start: 0, count: 300

body = JSON.parse response.body

results_html = body["results_html"]

content = Nokogiri::HTML(results_html)
content.css('.market_listing_row_link').each do |unusual_link|
  puts unusual_link['href']
end;
