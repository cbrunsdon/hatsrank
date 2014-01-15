require 'spec_helper'

describe Hatsrank::Client do
  let(:client) { Hatsrank::Client.new }

  describe '#unusual_hats' do
    use_vcr_cassette

    subject { client.unusual_hats }
    specify { subject.count > 400 }

    it 'should include the ourdoorsman' do
      subject.first.uri.should == "market/listings/440/Unusual%20Outdoorsman"
    end
  end

  describe '#listings' do
    use_vcr_cassette

    let(:hat) { Hatsrank::Hat.new client, 'http://steamcommunity.com/market/listings/440/Unusual%20Bombing%20Run' }
    subject { client.listings hat }

    specify { subject.first.item.name.should == "Unusual Bombing Run" }
  end
end
