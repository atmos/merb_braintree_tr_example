require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')


describe "visiting /credit_cards/1/delete", :given => "a user with a credit card in the vault" do
  before(:each) do
    @token = User.first.credit_cards.first.token
  end
  it "should display a form to submit the delete request to the vault" do
    response = request("/credit_cards/1", :method => 'DELETE')
    response.should be_successful
    response.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
    response.should have_selector("form input#customer_vault_id[value='#{@token}']")
    response.should have_selector("form input#customer_vault[value='delete_customer']")
  end
end
