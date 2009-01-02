require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "requesting", :given => 'an authenticated user' do
  describe "/" do
    it "should greet the user" do
      response = request("/")
      response.should be_successful
    end
  end
end
