module Braintree
  module Spec
    class ApiRequest
      def initialize(amount, params)
        @response = Braintree::GatewayRequest.new(:amount => amount).post(params)
      end

      def params
        params = @response.query_values
        params.reject! { |k,v| v == true }
      end
    end
  end
end
