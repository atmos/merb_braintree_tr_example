require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

module BrainTreeEditFormHelper
  class BrainTreeEditFormHelperForQuentin
    include Merb::Test::Matchers
    include Merb::Test::ViewHelper
    def matches?(target)
      target.should have_selector("form[action='https://secure.braintreepaymentgateway.com/api/transact.php'][method='post']")
      target.should have_selector("form input#firstname[value='Quentin']")
      target.should have_selector("form input#lastname[value='Blake']")
      target.should have_selector("form input#email[value='quentin@example.org']")
      target.should have_selector("form input#address1[value='187 Drive By Blvd']")
      target.should have_selector("form input#city[value='Compton']")
      target.should have_selector("form input#state[value='CA']")
      target.should have_selector("form input#zip[value='90220']")
      target.should have_selector("form input#country[value='US']")
      target.should have_selector("form input#ccexp[value='1010']")
      target.should have_selector("form input#customer_vault_id[value='#{User.first.credit_cards.first.token}']")
    end

    def failure_message
      "FAIL! :'("
    end
  end
  def display_a_credit_card_edit_form_for_quentin
    BrainTreeEditFormHelperForQuentin.new
  end
end

describe "CreditCards#edit", :given => "a user with a credit card in the vault" do
  include BrainTreeEditFormHelper
  describe "/credit_cards/1/edit" do
    it "should display a braintree transparent redirect form for customer vault updating" do
      response = request("/credit_cards/1/edit")
      response.should be_successful
      response.should display_a_credit_card_edit_form_for_quentin
    end
  end
  describe "/credit_cards/1/edit_response" do
    describe "given a successful response" do
      it "store the response token in an associated object for the user" do
        query_params = {'ccexp' => '1011', 'customer_vault' => 'update_customer',
                        'customer_vault_id' => User.first.credit_cards.first.token,
                        'redirect' => 'http://example.org/credit_cards/1/edit_response' }

        api_response = Braintree::GatewayRequest.new.post(query_params)

        params = api_response.query_values
        params.reject! { |k,v| v == true }

        response = request("/credit_cards/1/edit_response", :params => params)

        response.should redirect_to('/credit_cards')

        response = request(response.headers['Location'])
        response.should be_successful
        response.should have_selector("div#main-container:contains('Successfully updated your info in the vault.')")
        response.should have_selector("div#main-container table tbody td")
      end
    end
    describe "given a missing ccexp field" do
      it "should display the error messages to the user" do
        query_params = {'ccexp' => '', 'customer_vault' => 'update_customer',
                        'customer_vault_id' => User.first.credit_cards.first.token,
                        'redirect' => 'http://example.org/credit_cards/1/edit_response' }

        api_response = Braintree::GatewayRequest.new.post(query_params)

        params = api_response.query_values
        params.reject! { |k,v| v == true }

        response = request("/credit_cards/1/edit_response", :params => params)
        response.should redirect_to('/credit_cards/1/edit')

        response = request(response.headers['Location'])
        response.should be_successful
        response.should have_selector("div#main-container:contains('Field required: ccexp REFID:')")
        response.should display_a_credit_card_edit_form_for_quentin
      end
    end
  end
end
