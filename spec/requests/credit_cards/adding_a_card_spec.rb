require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "visiting /credit_cards/new", :given => 'an authenticated user' do
  it "should display a form with the necessary input to create a vault entry" do
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
    response.should have_selector("form input#cvv[value=''][type='text']")

    response.should have_selector("form input#type[value='sale'][type='hidden']")
    response.should have_selector("form input#amount[value='10.00'][type='hidden']")
    response.should have_selector("form input#orderid[value=''][type='hidden']")
    response.should have_selector("form input#hash[type='hidden']")
    response.should have_selector("form input#time[type='hidden']")
    response.should have_selector("form input#customer_vault[type='hidden'][value='add_customer']")
  end
end

describe "submitting the form at /credit_cards/new", :given => 'an authenticated user' do
  describe "and having it succeed" do
    it "should display basic info about the card stored in the vault" do
      params = quentin_form_info.merge({'type'=>'sale','payment' => 'creditcard'})
      api_response = Braintree::Spec::ApiRequest.new('10.00', params)

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
      params = quentin_form_info.merge({'type'=>'sale','payment' => 'creditcard'})
      api_response = Braintree::Spec::ApiRequest.new('0.99', params)

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
      response.should have_selector("form input#cvv[value=''][type='text']")

      response.should have_selector("form input#orderid[value=''][type='hidden']")
      response.should have_selector("form input#hash[type='hidden']")
      response.should have_selector("form input#time[type='hidden']")
      response.should have_selector("form input#customer_vault[type='hidden'][value='add_customer']")
    end
  end
  describe "and having it declined for bad cvv" do
    it "should display the signup form again, pre-populated with the info from the failed transaction" do
      params = quentin_form_info.merge({'type'=>'sale','payment' => 'creditcard', 'cvv' => '911'})
      api_response = Braintree::Spec::ApiRequest.new('10.00', params)

      response = request("/credit_cards/new_response", :params => api_response.params)
      response.should redirect_to("/credit_cards/new")

      response = request(response.headers['Location'])
      response.should be_successful
      response.should have_selector("div#main-container:contains('CVV2/CVC2 No Match')")
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
      response.should have_selector("form input#cvv[value=''][type='text']")

      response.should have_selector("form input#orderid[value=''][type='hidden']")
      response.should have_selector("form input#hash[type='hidden']")
      response.should have_selector("form input#time[type='hidden']")
      response.should have_selector("form input#customer_vault[type='hidden'][value='add_customer']")
    end
  end
end
