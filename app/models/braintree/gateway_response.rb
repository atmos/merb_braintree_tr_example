module Braintree
  class GatewayResponse

    attr_accessor :response, :responsetext, :response_code, :full_response, 
      :cvvresponse, :avsresponse, :time, :orderid, 
      :amount, :transactionid, :authcode, :username, 
      :customer_vault_id, :type, :hash, :response_status

    def initialize(attributes = nil)
      # FIXME: there is a much easier way to do this.
      attributes.delete_if { |param, value| param == "format" }
      attributes.delete_if { |param, value| param == "action" }
      attributes.delete_if { |param, value| param == "controller" }
      attributes.each { |k,v| self.send("#{k}=", v) } if attributes.any?
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
      hash == generated_hash
    end

    # Takes the values of the Gateway Response and generates a hash from them using
    # MD5 and format listed in the documentation.
    def generated_hash
      items = if customer_vault_id.nil?
        [orderid, amount, response, transactionid, avsresponse, cvvresponse, time, BRAINTREE[:key]]
      else
        [orderid, amount, response, transactionid, avsresponse, cvvresponse, customer_vault_id, time, BRAINTREE[:key]]
      end
      Digest::MD5.hexdigest(items.join('|'))
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
