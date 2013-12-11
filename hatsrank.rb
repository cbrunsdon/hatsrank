require 'faraday'
require 'json'

conn = Faraday.new(:url => 'http://steamcommunity.com') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
end

response = conn.get 'market/listings/440/Unusual%20Glengarry%20Bonnet/render/', query: '', start: 0, count: 50

body = JSON.parse response.body

class Listing
  attr_accessor :listing_id, :price, :currency, :item
end

class Item
  attr_accessor :name, :descriptions
  def initialize
    @descriptions = []
  end

  def effects
    descriptions.select { |x| x.value.match /^Effect/ }
  end

end

class Description
  attr_accessor :type, :value, :color

  def name
    value.sub 'Effect: ', ''
  end
end

# the values are the listings
listings = body["listinginfo"].values.map do |listing|
  l = Listing.new
  l.listing_id = listing['listingid']
  l.price = listing['price']
  l.currency = listing['currencyid']

  asset_info = listing['asset']
  asset_id = asset_info['id']
  asset_app = asset_info['appid']
  asset_context = asset_info['contextid']

  asset = body['assets'][asset_app.to_s][asset_context.to_s][asset_id.to_s]

  item = Item.new
  item.name = asset['name']

  asset['descriptions'].each do |description|
    d = Description.new
    d.type = description['type']
    d.value = description['value']
    d.color = description['color']
    item.descriptions << d
  end

  l.item = item
  l
end

listings.each do |listing|
  puts "#{listing.currency} - #{listing.price} - #{listing.item.effects.map(&:name).join ','}"
end;
