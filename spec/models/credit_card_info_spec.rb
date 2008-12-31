require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "CreditCard", :given => 'a user with a credit card in the vault' do
  before(:each) do
    user = User.first(:login => 'quentin')
  end
  describe "#info" do
    it "should know the card's first name" do
      CreditCard.get(1).info.first_name.should == "Quentin"
    end
    it "should know the card's last name" do
      CreditCard.get(1).info.last_name.should == "Blake"
    end
    it "should know the card's email address" do
      CreditCard.get(1).info.email.should == "quentin@example.org"
    end
    it "should know the card's address" do
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
    it "should know enough of the card user's credit card number to make it recognizable" do
      CreditCard.get(1).info.cc_number.should == "4xxxxxxxxxxx1111"
    end
    it "should know the card user's credit card expiration year and month" do
      CreditCard.get(1).info.cc_exp.should == "1010"
    end
  end
  describe "#info bad input" do
    it "should return empty strings if there's nil input on initialize" do
      CreditCardInfo.new.address_1.should == ''
    end
    it "should return empty strings if there's an empty string on initialize" do
      CreditCardInfo.new('').address_1.should == ''
    end
  end
end
