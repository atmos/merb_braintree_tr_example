require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/credit_cards" do
  before(:each) do
    @response = request("/credit_cards")
  end
end