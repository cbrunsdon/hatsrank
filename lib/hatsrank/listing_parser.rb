require 'hatsrank/listing'
require 'hatsrank/item'

module Hatsrank
  class ListingParser
    def initialize listing_hash, asset_hash
      @listing_hash = listing_hash
      @asset_hash = asset_hash
    end

    def listings
      listings = @listing_hash.values.map do |listing|

        l = Listing.new
        l.listing_id = listing['listingid']
        l.price      = listing['price']
        l.currency   = listing['currencyid']

        asset_info    = listing['asset']
        asset_id      = asset_info['id']
        asset_app     = asset_info['appid']
        asset_context = asset_info['contextid']

        asset = @asset_hash[asset_app.to_s][asset_context.to_s][asset_id.to_s]

        item = Item.new
        item.name = asset['name']

        if asset['descriptions']
          asset['descriptions'].each do |description|
            d        = Description.new
            d.type   = description['type']
            d.value  = description['value']
            d.color  = description['color']
            item.descriptions << d
          end
        end

        l.item = item
        l
      end
    end
  end
end
