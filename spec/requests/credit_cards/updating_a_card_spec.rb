require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "CreditCards#edit", :given => 'an authenticated user' do
  describe "/credit_cards/1/edit" do
    it "should display a braintree transparent redirect form for customer vault updating" do
      response = request("/credit_cards/1/edit")
      response.should be_successful
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
      response.should have_selector("form input#firstname[value='Quentin']")
      response.should have_selector("form input#lastname[value='Blake']")
      response.should have_selector("form input#email[value='quentin@example.com']")
      response.should have_selector("form input#address1[value='187 Drive By Blvd']")
      response.should have_selector("form input#city[value='Compton']")
      response.should have_selector("form input#state[value='CA']")
      response.should have_selector("form input#country[value='US']")
      response.should have_selector("form input#ccexp[value='1010']")
      response.should have_selector("form input#customer_vault_id[value='407702761']")
    end
  end
end
