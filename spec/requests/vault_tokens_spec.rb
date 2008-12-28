require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/vault_tokens" do
  before(:each) do
    @response = request("/vault_tokens")
  end
end