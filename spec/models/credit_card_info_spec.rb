require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "CreditCardInfo" do
  before(:each) do
    user = User.first(:login => 'quentin')
    user.credit_cards.create(:token => '407702761')
  end
  it "should know the card user's first name" do
    CreditCard.get(1).info.first_name.should == "Quentin"
  end
  it "should know the card user's last name" do
    CreditCard.get(1).info.last_name.should == "Blake"
  end
  it "should know the card user's email address" do
    CreditCard.get(1).info.email.should == "quentin@example.com"
  end
  it "should know the card user's address" do
    CreditCard.get(1).info.address_1.should == "187 Drive By Blvd"
  end
  it "should know the card user's city" do
    CreditCard.get(1).info.city.should == "Compton"
  end
  it "should know the card user's state" do
    CreditCard.get(1).info.state.should == "CA"
  end
  it "should know the card user's postal code" do
    CreditCard.get(1).info.postal_code.should == "90220"
  end
  it "should know the card user's country" do
    CreditCard.get(1).info.country.should == "US"
  end
  it "should know the card user's ccexp" do
    CreditCard.get(1).info.cc_exp.should == "1010"
  end
  it "should return empty strings if there's no customer node" do
    CreditCardInfo.new.address_1.should == ''
  end
  it "should return empty strings if there's no customer node" do
    CreditCardInfo.new('').address_1.should == ''
  end
end
