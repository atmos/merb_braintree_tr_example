require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "updating credit card info", :given => "a user with a credit card in the vault" do
  include BrainTreeEditFormHelper

  describe "requesting the form to update the card" do
    it "should display a form for customer vault updating" do
      response = request("/credit_cards/1/edit")
      response.should be_successful
      response.should display_a_credit_card_edit_form_for_quentin
    end
  end

  describe "after submitting the form" do
    describe "and a successful response" do
      it "tells the user that updating succeeded" do
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
    describe "and a missing ccexp field" do
      it "tells the user that updating failed" do
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
