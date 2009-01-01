module Braintree
  class TransactionInfo < Query
    xml_attrs :first_name, :last_name, :email, :address_1, :city, :state, :postal_code, :country
    xml_attrs :cc_number, :cc_exp

    def initialize(transaction_id = nil)
      super({:transaction_id => transaction_id, :transaction_type => 'cc', :action_type => 'sale'})
      @transaction_id = transaction_id
      @info = Braintree::Query.new(@query_params).run 
    end

    def date
      xml_attribute('action/date')
    end

    def amount
      xml_attribute('action/amount')
    end
  end
end
