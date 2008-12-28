require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "Payments#new", :given => 'an authenticated user' do
  before(:each) do
    user = User.first(:login => 'quentin')
    user.credit_cards.create(:token => '1838120349')
  end
  describe "/credit_cards/1/payments/new" do
    it "should display a form telling you to be more awesome" do
      response = request("/credit_cards/1/payments/new")
      response.should be_successful
      pending
    end
  end
end
