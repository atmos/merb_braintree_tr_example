module Merb
  module PaymentsHelper
    def card_holders_name(card_record)
      "#{card_record.first_name} #{card_record.last_name}"
    end

    def card_billing_address(card_record)
      "#{card_record.address_1} (#{card_record.postal_code})"
    end
  end
end # Merb
