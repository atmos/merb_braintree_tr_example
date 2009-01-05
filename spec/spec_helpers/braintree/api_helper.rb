module Braintree
  module Spec
    class ApiRequest
      def initialize(amount, customer_vault_id, params)
        @response = Braintree::GatewayRequest.new(:amount => amount, :customer_vault_id => customer_vault_id).post(params)
      end

      def params
        params = @response.query_values
        params.reject { |k,v| v == true }
      end
    end
  end
end
