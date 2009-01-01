require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "CreditCard", :given => 'a user with a credit card in the vault' do
  describe "#info" do
    before(:each) do
      @cc = CreditCard.get(1)
    end
    it "should know the card's first name" do
      @cc.info.first_name.should == "Quentin"
    end
    it "should know the card's last name" do
      @cc.info.last_name.should == "Blake"
    end
    it "should know the card's email address" do
      @cc.info.email.should == "quentin@example.org"
    end
    it "should know the card's address" do
      @cc.info.address_1.should == "187 Drive By Blvd"
    end
    it "should know the card user's city" do
      @cc.info.city.should == "Compton"
    end
    it "should know the card user's state" do
      @cc.info.state.should == "CA"
    end
    it "should know the card user's postal code" do
      @cc.info.postal_code.should == "90220"
    end
    it "should know the card user's country" do
      @cc.info.country.should == "US"
    end
    it "should know enough of the card user's credit card number to make it recognizable" do
      @cc.info.cc_number.should == "4xxxxxxxxxxx1111"
    end
    it "should know the card user's credit card expiration year and month" do
      @cc.info.cc_exp.should == "1010"
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
