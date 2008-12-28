require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "Payments", :given => 'an authenticated user' do
  describe "/vault_tokens/new" do
    it "should display a braintree transparent redirect form for customer vault creation" do
      response = request("/vault_tokens/new")
      response.should be_successful
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
    end
  end
  describe "/vault_tokens/new_response" do
    before(:each) do
      @gateway_request = Braintree::GatewayRequest.new
    end
    describe "given a successful response" do
      it "store the response token in an associated object for the user" do
        request_params = {"avsresponse" => "", "response"=> "1", 
                          "authcode"    => "", "orderid" => "", 
                          "customer_vault_id"=>"1074650921", "responsetext"=>"Customer Added", 
                          "hash"=> @gateway_request, "response_code"=>"100", 
                          "username"=>"776320", "time"=>@gateway_request.time,
                          "amount"=>"", "transactionid"=>"0", 
                          "type"=>"", "cvvresponse"=>""}
        response = request("/vault_tokens/new_response", :params => request_params)
        response.should redirect_to('/')

        response = request(response.headers['Location'])
        response.should be_successful
        response.should have_selector("div#main-container:contains('Successfully stored your card info securely.')")
        response.should have_selector("div#main-container table tbody td")
      end
    end

    describe "given an invalid card number" do
      it "should display the card input form again" do
        request_params = {"avsresponse"=>"", 
                          "response"=>"3", 
                          "authcode"=>"", "orderid"=>"", 
                          "responsetext"=>"Invalid card number REFID:999999999", 
                          "hash"=> @gateway_request.hash,
                          "response_code"=>"300", 
                          "username"=>"776320", 
                          "time"=> @gateway_request.time,
                          "amount"=>"", 
                          "transactionid"=>"0", 
                          "type"=>"", 
                          "cvvresponse"=>""}
        response = request("/vault_tokens/new_response", :params => request_params)
        response.should redirect_to('/vault_tokens/new')

        response = request(response.headers['Location'])
        response.should be_successful
        response.should have_selector("div#main-container:contains('Invalid card number REFID:999999999')")
        response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
      end
    end
  end
end