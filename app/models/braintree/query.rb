module Braintree
  class Query
    include LibXML
    def self.xml_attrs(*args)
      args.each do |xml_attr|
        class_eval <<-METHOD_DEF
          def #{xml_attr}
            @#{xml_attr} = xml_attribute('#{xml_attr}')
          end
        METHOD_DEF
      end
    end

    def xml_attribute(path)
      result = @info.find("/nm_response/transaction/#{path}")
      (result.nil?||result.first.nil?) ? '' : result.first.content
    end

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
