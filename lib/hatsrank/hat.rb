module Hatsrank
  class Hat
    attr_reader :uri

    def initialize(client, uri)
      @uri = uri.sub('http://steamcommunity.com/', '')
      @client = client
    end

    def listings
      @client.listings
    end

    def info
      @client.hat_info self
    end

    def name
      listings.first.name
    end

  end
end
