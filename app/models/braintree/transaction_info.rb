module Braintree
  class TransactionInfo
    attr_reader :first_name, :last_name, :email, :address_1, :city, :state, :postal_code, :country
    attr_reader :cc_number, :cc_exp, :amount, :date

    def initialize(transaction_id = nil)
      @transaction_id = transaction_id
      run
    end

    def run
      query_params = {:transaction_id => @transaction_id, :transaction_type => 'cc', :action_type => 'sale'}
      info = Braintree::Query.new(query_params).run 
      @first_name  = info.find('/nm_response/transaction/first_name').first.content
      @last_name   = info.find('/nm_response/transaction/last_name').first.content
      @email       = info.find('/nm_response/transaction/email').first.content
      @address_1   = info.find('/nm_response/transaction/address_1').first.content
      @city        = info.find('/nm_response/transaction/city').first.content
      @state       = info.find('/nm_response/transaction/state').first.content
      @postal_code = info.find('/nm_response/transaction/postal_code').first.content
      @country     = info.find('/nm_response/transaction/country').first.content
      @cc_exp      = info.find('/nm_response/transaction/cc_exp').first.content
      @amount      = info.find('/nm_response/transaction/action/amount').first.content
      @date        = info.find('/nm_response/transaction/action/date').first.content
      @cc_number   = info.find('/nm_response/transaction/cc_number').first.content
    end
  end
end
