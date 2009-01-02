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

  describe "and having it succeed" do
    it "should display basic card info in the ui" do
      api_response = Braintree::Spec::ApiRequest.new('10.00', quentin_form_info.merge({'type'=>'sale','payment' => 'creditcard'}))

      response = request("/credit_cards/new_response", :params => api_response.params)
      response.should redirect_to('/')

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('Successfully stored your card info securely.')")
      response.should have_selector("div#main-container table tbody td")
    end
  end

  describe "and having it declined" do
    it "should display the signup form again, pre-populated with the info from the failed transaction" do
      api_response = Braintree::Spec::ApiRequest.new('0.99', quentin_form_info.merge({'type'=>'sale','payment' => 'creditcard'}))

      response = request("/credit_cards/new_response", :params => api_response.params)
      response.should redirect_to("/credit_cards/new")

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('DECLINE')")
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
      response.should have_selector("form input#firstname[value='Quentin']")
      response.should have_selector("form input#lastname[value='Blake']")
      response.should have_selector("form input#email[value='quentin@example.org']")
      response.should have_selector("form input#address1[value='187 Drive By Blvd']")
      response.should have_selector("form input#city[value='Compton']")
      response.should have_selector("form input#state[value='CA']")
      response.should have_selector("form input#zip[value='90220']")
      response.should have_selector("form input#country[value='US']")
      response.should have_selector("form input#ccnumber[value='']")
      response.should have_selector("form input#ccexp[value='1010']")
    end
  end
end
