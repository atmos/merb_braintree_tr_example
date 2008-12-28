require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

module BrainTreeEditFormHelper
  class BrainTreeEditFormHelperForQuentin
    include Merb::Test::Matchers
    include Merb::Test::ViewHelper
    def matches?(target)
      target.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
      target.should have_selector("form input#firstname[value='Quentin']")
      target.should have_selector("form input#lastname[value='Blake']")
      target.should have_selector("form input#email[value='quentin@example.com']")
      target.should have_selector("form input#address1[value='187 Drive By Blvd']")
      target.should have_selector("form input#city[value='Compton']")
      target.should have_selector("form input#state[value='CA']")
      target.should have_selector("form input#country[value='US']")
      target.should have_selector("form input#ccexp[value='1010']")
      target.should have_selector("form input#customer_vault_id[value='407702761']")
    end

    def failure_message
      "FAIL! :'("
    end
  end
  def display_a_credit_card_edit_form_for_quentin
    BrainTreeEditFormHelperForQuentin.new
  end
end

describe "CreditCards#edit", :given => 'an authenticated user' do
  include BrainTreeEditFormHelper
  describe "/credit_cards/1/edit" do
    it "should display a braintree transparent redirect form for customer vault updating" do
      response = request("/credit_cards/1/edit")
      response.should be_successful
      response.should display_a_credit_card_edit_form_for_quentin
    end
  end
  describe "/credit_cards/1/edit_response" do
    before(:each) do
      @gateway_request = Braintree::GatewayRequest.new
    end
    describe "given a successful response" do
      it "store the response token in an associated object for the user" do
        request_params = {"avsresponse"=>"", "response"=>"1", 
                          "authcode"=>"", "orderid"=>"", 
                          "customer_vault_id"=>"407702761", 
                          "responsetext"=>"Customer Update Successful", 
                          "hash"=>@gateway_request.hash, "response_code"=>"100", 
                          "username"=>"776320", "time"=>@gateway_request.time, 
                          "amount"=>"", "transactionid"=>"0", "type"=>"", "cvvresponse"=>"" }
        response = request("/credit_cards/1/edit_response", :params => request_params)
        response.should redirect_to('/credit_cards')

        response = request(response.headers['Location'])
        response.should be_successful
        response.should have_selector("div#main-container:contains('Successfully updated your info in the vault.')")
        response.should have_selector("div#main-container table tbody td")
      end
    end
    describe "given a missing ccexp field" do
      it "should display the error messages to the user" do
        request_params = { "avsresponse"=>"", "response"=>"3", 
                           "authcode"=>"", "orderid"=>"", 
                           "responsetext"=>"Field required: ccexp REFID:100585802", 
                           "hash"=>@gateway_request.hash, "response_code"=>"300", 
                           "username"=>"776320", "time"=>@gateway_request.time, 
                           "amount"=>"", "transactionid"=>"0", "type"=>"", 
                           "cvvresponse"=>""}

        response = request("/credit_cards/1/edit_response", :params => request_params)
        response.should redirect_to('/credit_cards/1/edit')

        response = request(response.headers['Location'])
        response.should be_successful
        response.should have_selector("div#main-container:contains('Field required: ccexp REFID:100585802')")
        response.should display_a_credit_card_edit_form_for_quentin
      end
    end
  end
end
