module Merb
  module GlobalHelpers
    include Merb::CreditCardsHelper

    def braintree_date_reformatter(str)
      DateTime.parse(str).strftime('%Y/%m/%d %H:%M:%S')
    end
  end
end
