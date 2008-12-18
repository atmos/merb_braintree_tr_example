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
  describe "/payments/add_card" do
    it "should display a braintree transparent redirect form for vault addition" do
      pending
      response = request("/payments/add_card")
      response.should be_successful
      response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
    end
  end
end
