module BrainTree
  class Query
    include LibXML
    def initialize(query_params)
      @query_params = query_params.merge({ 
                              'username' => BRAINTREE[:username],
                              'password' => BRAINTREE[:password]})
    end

    def run
      uri = Addressable::URI.parse(BRAINTREE[:query_api_url])

      server = Net::HTTP.new(uri.host, 443)
      server.use_ssl = true
      server.read_timeout = 20
      server.verify_mode = OpenSSL::SSL::VERIFY_NONE

      resp = server.start do |http|
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(@query_params)
        http.request(req)
      end
      case resp
      when Net::HTTPSuccess, Net::HTTPRedirection
        result = LibXML::XML::Document.string(resp.body)
      else
        resp.error!
      end
    end
  end
end
