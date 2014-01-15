require 'spec_helper'

describe Hatsrank::Hat do
  let(:url) { 'http://steamcommunity.com/market/listings/440/Unusual%20Bombing%20Run' }
  let(:client) { Hatsrank::Client.new }

  let(:hat) { Hatsrank::Hat.new client, url }

  describe '#listings' do
    let(:hat_list) { 'hats' }
    before do
      client.should_receive(:listings).and_return hat_list
    end

    it 'calls hats from the client' do
      hat.listings.should == hat_list
    end

  end

end
