require 'spec_helper'

describe Hatsrank::Listing do
  let(:listing) { Hatsrank::Listing.new }
  let(:price) { 5000 }
  before do
    Money.default_bank.add_rate 'GBP', 'USD', 1.1

    listing.currency = currency
    listing.price = price
  end
  describe 'usd' do
    use_vcr_cassette
    subject { listing.usd }

    context 'currency does not exist' do
      let(:currency) { 9999 }

      it 'throws an exception' do
        expect { listing.usd }.to raise_error { Hatsrank::Listing::UnknownCurrencyException }
      end
    end

    context 'currency is GBP' do
      let(:currency) { 2002 }
      specify { subject.to_s.should == "55.00" }
    end
  end
end
