require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Payments", :given => 'an authenticated user' do
  describe "/payments" do
    it "should greet the user" do
      response = request("/payments")
      response.should be_successful
    end
  end
  describe "/payments/signup" do
    it "should display a braintree transparent redirect form for customer vault creation" do
      response = request("/payments/signup")
      response.should be_successful
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
    end
  end
  describe "/payments/signup_response" do
    describe "given a successful response" do
      it "store the response token in an associated object for the user" do
        pending
        request_params = {"avsresponse" => "", "response"=> "1", 
                          "authcode"    => "", "orderid" => "", 
                          "customer_vault_id"=>"1074650921", "responsetext"=>"Customer Added", 
                          "hash"=>"d6f406b3c7edff913e0ba86b91af2fd0", "response_code"=>"100", 
                          "username"=>"776320", "time"=>"20081222181133", 
                          "amount"=>"", "transactionid"=>"0", 
                          "type"=>"", "cvvresponse"=>""}
        response = request("/payments/signup_response", :params => request_params)
        response.should be_successful
      end
    end
  end
  describe "/payments/add_card" do
    it "should display a braintree transparent redirect form for vault addition" do
      pending
      response = request("/payments/add_card")
      response.should be_successful
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
    end
  end
end
