module Merb
  module CreditCardsHelper
    def fetch_credit_card(id)
      @credit_card = CreditCard.get(id)
      raise NotFound if @credit_card.nil?
      raise Unauthorized unless @credit_card.user_id == session.user.id
    end
  end
end # Merb
