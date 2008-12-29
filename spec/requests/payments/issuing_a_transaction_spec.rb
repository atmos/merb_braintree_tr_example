require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "Payments", :given => 'an authenticated user' do
  before(:each) do
    @time = Braintree::GatewayRequest.new.time
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
          gw_response = Braintree::GatewayResponse.new(:orderid => '', :amount => '10.0', :authcode => '123456',
                                                       :response => '1', :transactionid => '873726993',
                                                       :avsresponse => 'N', :cvvresponse => '', :time => @time)
          response_params = { "avsresponse"=>"N", "response"=>"1", 
                              "authcode"=>"123456", "orderid"=>"", 
                              "responsetext"=>"SUCCESS", "hash"=> gw_response.generated_hash,
                              "response_code"=>"100", "username"=>"776320", "time"=> gw_response.time,
                              "amount"=>"10.0", "transactionid"=>"873726993", 
                              "type"=>"sale", "cvvresponse"=>""} 

          response = request("/credit_cards/1/payments/new_response", :params => response_params)
          response.should redirect_to("/credit_cards/1")

          response = request(response.headers['Location'])
          response.should be_successful
        end
      end
      describe "given a failed transaction" do
        it "send you back to the form with an informative message" do
          gw_response = Braintree::GatewayResponse.new(:orderid => '', :amount => '0.99', :authcode => '',
                                                       :response => '2', :transactionid => '873766046',
                                                       :avsresponse => 'N', :cvvresponse => '', :time => @time)
          response_params = { "avsresponse"=>"N", "response"=>"2", 
                              "authcode"=>"", "orderid"=>"", 
                              "responsetext"=>"SUCCESS", "hash"=> gw_response.generated_hash,
                              "response_code"=>"200", "username"=>"776320", "time"=> gw_response.time,
                              "amount"=>"0.99", "transactionid"=>"873766046", 
                              "type"=>"sale", "cvvresponse"=>""} 

          response = request("/credit_cards/1/payments/new_response", :params => response_params)
          response.should redirect_to("/credit_cards/1/payments/new")

          response = request(response.headers['Location'])
          response.should be_successful
        end
      end
    end
  end
end
