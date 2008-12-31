require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "adding a credit card", :given => 'an authenticated user' do
  describe "the signup form" do
    it "should be valid" do
      response = request("/credit_cards/new")
      response.should be_successful
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
      response.should have_selector("form input#firstname[value='']")
      response.should have_selector("form input#lastname[value='']")
      response.should have_selector("form input#email[value='']")
      response.should have_selector("form input#address1[value='']")
      response.should have_selector("form input#city[value='']")
      response.should have_selector("form input#state[value='']")
      response.should have_selector("form input#country[value='']")
      response.should have_selector("form input#ccnumber[value='']")
      response.should have_selector("form input#ccexp[value='']")

      response.should have_selector("form input#type[value='sale'][type='hidden']")
      response.should have_selector("form input#amount[value='10.00'][type='hidden']")
    end
  end
  describe "a successful transaction on signup" do
    it "should be successful and display basic card info in the ui" do
      api_response = Braintree::GatewayRequest.new(:amount => '10.00').post(quentin_form_info)
      params = api_response.query_values
      params.reject! { |k,v| v == true }

      response = request("/credit_cards/new_response", :params => params)
      response.should redirect_to('/')

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('Successfully stored your card info securely.')")
      response.should have_selector("div#main-container table tbody td")
    end
  end
  describe "a declined transaction on signup" do
    it "should be successful and display basic card info in the ui" do
      api_response = Braintree::GatewayRequest.new(:amount => '0.99').post(quentin_form_info)
      params = api_response.query_values
      params.reject! { |k,v| v == true }

      response = request("/credit_cards/new_response", :params => params)
      response.should redirect_to("/credit_cards/new")

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('DECLINE')")
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
#      response.should have_selector("form input#firstname[value='Quentin']")
#      response.should have_selector("form input#lastname[value='Blake']")
#      response.should have_selector("form input#email[value='quentin@example.org']")
#      response.should have_selector("form input#address1[value='187 Drive By Blvd']")
#      response.should have_selector("form input#city[value='Compton']")
#      response.should have_selector("form input#state[value='CA']")
#      response.should have_selector("form input#country[value='US']")
#      response.should have_selector("form input#ccnumber[value='']")
#      response.should have_selector("form input#ccexp[value='']")
    end
  end
end
