require 'faraday'
require 'json'
require 'nokogiri'
require 'money'

module Hatsrank
  class Client
    def unusual_hats
      response = faraday.get 'market/search/render/', query: 'appid:440 unusual', search_descriptions: 0, start: 0, count: 1000

      body = JSON.parse response.body

      results_html = body["results_html"]

      content = Nokogiri::HTML(results_html)
      content.css('.market_listing_row_link').map do |marketable_link|
        Marketable.new self, marketable_link['href']
      end

    end

    def listings hat
      response = faraday.get hat.uri + '/render/', query: '', start: 0, count: 100
      body = JSON.parse response.body

      # the values are the listings
      listings = body["listinginfo"].values.map do |listing|
        l = Listing.new
        l.listing_id = listing['listingid']
        l.price      = listing['price']
        l.currency   = listing['currencyid']

        asset_info    = listing['asset']
        asset_id      = asset_info['id']
        asset_app     = asset_info['appid']
        asset_context = asset_info['contextid']

        asset = body['assets'][asset_app.to_s][asset_context.to_s][asset_id.to_s]

        item = Item.new
        item.name = asset['name']

        asset['descriptions'].each do |description|
          d        = Description.new
          d.type   = description['type']
          d.value  = description['value']
          d.color  = description['color']
          item.descriptions << d
        end

        l.item = item
        l
      end
    end

    private
    def faraday
      @conn = Faraday.new(:url => 'http://steamcommunity.com') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end

  class Description
    attr_accessor :type, :value, :color

    def name
      value.sub 'Effect: ', ''
    end
  end

end
