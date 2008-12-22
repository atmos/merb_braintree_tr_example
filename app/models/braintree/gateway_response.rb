module Braintree
  class GatewayResponse

    attr_accessor :response, :responsetext, :response_code, :full_response, 
      :cvvresponse, :avsresponse, :returned_hash, :time, :orderid, 
      :amount, :transactionid, :authcode, :username, 
      :customer_vault_id, :type, :hash, :response_status

    def initialize(attributes = nil)
      # FIXME: there is a much easier way to do this.
      attributes.delete_if { |param, value| param == "action" }
      attributes.delete_if { |param, value| param == "controller" }
      attributes.each { |k,v| self.send("#{k}=", v) } if attributes.any?
    end

    def to_order_attributes
      { :orderid => orderid, :amount => amount, :response => response,
        :responsetext => responsetext, :authcode => authcode, 
        :transactionid => transactionid, :avsresponse => avsresponse,
        :cvvresponse => cvvresponse, :response_code => response_code,
        :full_response => full_response, :status => response_status,
        :response_hash => returned_hash } 
    end

    # This value can be displayed in the flash.
    def message_for_success
      "Your card has been successfully charged."
    end

    def message_for_failure
      "Your card was declined."
    end

    # Tests the response given back to determine whether the transaction
    # was successful.  
    def is_successful?
      self.response == "1" ? true : false
    end

    def is_declined?
      self.response == "2" ? true : false
    end

    def is_error?
      self.response == "3" ? true : false
    end

    # Copies the returned value "hash" to returned_hash attributes since the
    # word 'hash' is a method of ActiveRecord::Base.
    def returned_hash
      self.hash
    end

    # A string representation of the response status given as a number.
    def response_status
      case self.response
      when "1"
        "approved"
      when "2"
        "declined"
      when "3"
        "error"
      end
    end

    # The hash sent with the Gateway Response should equal a hash that can get
    # generated using the key and the sent parameters.
    def is_valid?
      return true if self.hash == self.generated_hash
    end

    # Takes the values of the Gateway Response and generates a hash from them using
    # MD5 and format listed in the documentation.
    def generated_hash
      Digest::MD5.hexdigest([self.orderid, self.amount, self.response,
                            self.transactionid, self.avsresponse,
                            self.cvvresponse, self.time, BRAINTREE[:key]].join("|"))
    end

    # Takes a query string parameter and breaks it down in key/value hash pairs
    # FIXME: should break down string on initialize
    def attributes_to_hash(string)
      attributes = { }

      string.split("&").each do |pair|
        pair_array = pair.split("=")
        attributes[pair_array[0].intern] = pair_array[1]
      end

      return attributes
    end

    # AVS_RESPONSE_CODES
    def avs_matches?
      self.avsresponse.include?("Y")
    end

    # CVV_RESPONSE_CODES
    def cvv_matches?
      self.cvvresponse == "M" ? true : false
    end

    def cvvresponse_string
      case self.cvvresponse
      when "M"
        "CVV2/CVC2 Match"
      when "N"
        "CVV2/CVC2 No Match"
      when "P"
        "Not Processed"
      when "S"
        "Merchant has indicated the CVV2/CVC2 is not present on card"
      when "U"
        "Issuer is not certified and/or has not provided Visa encryption keys"
      end
    end
  end
end
