require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "Payments", :given => 'a user with a credit card in the vault' do
  before(:each) do
    @token = User.first.credit_cards.first.token
  end
  describe "#new" do
    describe "/credit_cards/1/payments/new" do
      it "should display a form telling you that you'll be charged 10.00" do
        response = request("/credit_cards/1/payments/new")
        response.should be_successful
      end
    end
  end
  describe "#new_response" do
    describe "/credit_cards/1/payments/new_response" do
      describe "given a successful transaction" do
        it "should redirect to the credit card and display the transaction" do
          query_params = { 'customer_vault_id' => @token, 'type' => 'sale', 'amount' => '10.00',
                           'redirect' => 'http://example.org/credit_cards/1/new_response' }

          api_response = Braintree::GatewayRequest.new(:amount => '10.00').post(query_params)
          params = api_response.query_values
          params.reject! { |k,v| v == true }

          response = request("/credit_cards/1/payments/new_response", :params => params)
          response.should redirect_to("/credit_cards/1")

          response = request(response.headers['Location'])
          response.should be_successful
          response.should have_selector("div#main-container:contains('Successfully charged your Credit Card.')")

        end
      end
      describe "given a failed transaction" do
        it "send you back to the form with an informative message" do
          query_params = { 'customer_vault_id' => @token, 'type' => 'sale', 'amount' => '0.99',
                           'redirect' => 'http://example.org/credit_cards/1/new_response' }

          api_response = Braintree::GatewayRequest.new(:amount => '10.00').post(query_params)
          params = api_response.query_values
          params.reject! { |k,v| v == true }

          response = request("/credit_cards/1/payments/new_response", :params => params)
          response.should redirect_to("/credit_cards/1/payments/new")

          response = request(response.headers['Location'])
          response.should be_successful
        end
      end
    end
  end
end
