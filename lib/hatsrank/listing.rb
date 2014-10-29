module Hatsrank
  class Listing
    attr_accessor :listing_id, :price, :currency, :item

    def money
      ::Money.new(price, currency_symbol)
    end

    def usd
      money.exchange_to(:USD)
    end

    class UnknownCurrencyException < Exception
      def initialize(currency)
        @currency = currency
      end
      def message
        "Currency #{@currency} not found"
      end
    end

    private
    def currency_symbol
      case currency.to_i
      when 2001
        'USD'
      when 2002
        'GBP'
      when 2003
        'EUR'
      when 2005
        'RUB'
      else
        raise UnknownCurrencyException.new(currency)
      end
    end
  end

end
