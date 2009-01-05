require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "visiting /credit_cards/1/payments/new", :given => 'a user with a credit card in the vault' do
  it "should display a form telling you that you'll be charged 10.00" do
    response = request("/credit_cards/1/payments/new")
    response.should be_successful
  end
end

describe "submitting the form at /credit_cards/1/payments/new", :given => 'a user with a credit card in the vault' do
  before(:each) do
    @token = User.first.credit_cards.first.token
  end
  describe "given a successful transaction" do
    it "should redirect to the credit card's page and display the transaction" do
      query_params = { 'customer_vault_id' => @token, 'type' => 'sale', 'amount' => '10.00',
                       'redirect' => 'http://example.org/credit_cards/1/new_response' }

      api_response = Braintree::Spec::ApiRequest.new('10.00', @token, query_params)

      response = request("/credit_cards/1/payments/new_response", :params => api_response.params)
      response.should redirect_to("/credit_cards/1")

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('Successfully charged your Credit Card.')")
    end
  end
  describe "given a failed transaction" do
    it "send you back to the form telling you the payment was declined" do
      query_params = { 'customer_vault_id' => @token, 'type' => 'sale', 'amount' => '0.99',
                       'redirect' => 'http://example.org/credit_cards/1/new_response' }

      api_response = Braintree::Spec::ApiRequest.new('0.99', @token, query_params)

      response = request("/credit_cards/1/payments/new_response", :params => api_response.params)
      response.should redirect_to("/credit_cards/1/payments/new")

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('DECLINE')")
    end
  end
end
