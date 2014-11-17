require 'spec_helper'

describe StripeWrapper::Charge do
  before do
    StripeWrapper::Charge.set_api_key
  end
  let (:token) do
      Stripe::Token.create(
        :card => {
          :number => card_number,
          :exp_month => 3,
          :exp_year => 2017, 
          :cvc => 123
          }
        ).id
  end
  context "with valid credit card" do
    let(:card_number) {"4242 4242 4242 4242"}
    it "charges the card successfully" do
      response = StripeWrapper::Charge.create( :amount => 100, :currency => "usd", :card => token, :description => "test ")
       response.should be_successful
    end
  end
  context "with INvalid credit card" do
    let(:card_number) { "4000000000000069"} #expired card
    let(:response) { StripeWrapper::Charge.create(:amount => 100, :currency => "usd", :card => token)  }

    it "does NOT charge the card " do
      response.should_not be_successful
    end

    it "returns an error message " do
      response.error_message.should == "Your card has expired."
    end
  end
  

end
