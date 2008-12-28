require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Payments", :given => 'an authenticated user' do
  describe "/payments" do
    it "should greet the user" do
      response = request("/payments")
      response.should be_successful
    end
  end
end
