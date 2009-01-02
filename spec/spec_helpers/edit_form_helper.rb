require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

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

      target.should have_selector("form input#orderid[value=''][type='hidden']")
      target.should have_selector("form input#hash[type='hidden']")
      target.should have_selector("form input#time[type='hidden']")
      target.should have_selector("form input#customer_vault[type='hidden'][value='update_customer']")
    end

    def failure_message
      "FAIL! :'("
    end
  end
  def display_a_credit_card_edit_form_for_quentin
    BrainTreeEditFormHelperForQuentin.new
  end
end
