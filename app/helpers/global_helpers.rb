module Merb
  module GlobalHelpers
    def braintree_query(query_params)
      uri = Addressable::URI.parse(BRAINTREE[:query_api_url])

      server = Net::HTTP.new(uri.host, 443)
      server.use_ssl = true

      resp = server.start do |http|
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(query_params.merge({ 
                              'username' => BRAINTREE[:username],
                              'password' => BRAINTREE[:password]}))
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
