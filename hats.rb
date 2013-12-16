require 'faraday'
require 'json'

def faraday
  conn = Faraday.new(:url => 'http://steamcommunity.com') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
end
