require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "visiting /", :given => 'an authenticated user' do
  it "should greet the user" do
    response = request("/")
    response.should be_successful
  end
end
