load 'hats.rb'

require 'money'
require 'eu_central_bank'

eu_bank = EuCentralBank.new
Money.default_bank = eu_bank
eu_bank.update_rates

response = farady.get 'market/listings/440/Unusual%20Glengarry%20Bonnet/render/', query: '', start: 0, count: 50

body = JSON.parse response.body

class Listing
  attr_accessor :listing_id, :price, :currency, :item

  def money
    ::Money.new(price, currency_symbol)
  end

  def usd
    money.exchange_to(:USD)
  end

  private
  def currency_symbol
    case currency
    when 2001
      'USD'
    when 2002
      'GBP'
    when 2003
      'EUR'
    when 2005
      'RUB'
    else
      raise "Unknown Currency #{currency}: #{price}"
    end
  end
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
  puts "#{listing.usd.format} - #{listing.item.effects.map(&:name).join ','}"
end;
