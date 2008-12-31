module Braintree
  class GatewayRequest
    attr_accessor :orderid, :amount, :key, :key_id, :time, :response_url,
      :type, :customer_vault

    attr_reader :hash

    def initialize(attributes = nil)
      attributes.each { |k,v| self.send("#{k}=", v) } unless attributes.nil?
      self.key, self.key_id = BRAINTREE[:key], BRAINTREE[:key_id]
      self.time = self.class.formatted_time_value
    end

    def hash
      Digest::MD5.hexdigest([self.orderid, self.amount, self.time, self.key].join("|"))
    end

    def self.formatted_time_value
      Time.now.getutc.strftime("%Y%m%d%H%M%S")
    end

    def hash_attributes
      { 'orderid' => orderid, 'amount' => amount, 'key_id' => key_id, 
        'time' => time, 'hash' => hash }
    end

    def post(params)
      uri = Addressable::URI.parse(BRAINTREE[:transact_api_url])

      server = Net::HTTP.new(uri.host, 443)
      server.use_ssl = true
      server.read_timeout = 20
      server.verify_mode = OpenSSL::SSL::VERIFY_NONE

      resp = server.start do |http|
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(hash_attributes.merge(params))
        http.request(req)
      end
      case resp
      when Net::HTTPRedirection
        Addressable::URI.parse(resp.header['Location'])
      when Net::HTTPSuccess
        resp
      else
        resp.error!
      end
    end
  end
end
