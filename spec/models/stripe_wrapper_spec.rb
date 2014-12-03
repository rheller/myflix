require 'spec_helper'

describe StripeWrapper do 
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

  describe StripeWrapper::Customer do

    let (:hank) {Fabricate(:user)}
    describe ".create" do
      context "with valid credit card" do
        let(:card_number) {"4242 4242 4242 4242"}
        it "charges the card successfully", :vcr do
          response = StripeWrapper::Customer.create( :card => token, 
                                    :plan => "ricktestplan", 
                                    :user => hank)
          expect(response).to be_successful
        end
      end
      context "with INvalid credit card" do
        let(:card_number) { "4000000000000069"} #expired card
        let(:response) { StripeWrapper::Customer.create( :card => token,   :plan => "ricktestplan", :user => hank) }

        it "does not charge the card ", :vcr do
          expect(response).to_not be_successful
        end

        it "returns an error message ", :vcr do
          expect(response.error_message).to be_present
        end
      end
    end
  end
######################################
  describe StripeWrapper::Charge do

    describe ".create" do

      context "with valid credit card" do
        let(:card_number) {"4242 4242 4242 4242"}
        it "charges the card successfully", :vcr do
          response = StripeWrapper::Charge.create( :amount => 99, :currency => "usd", :card => token, :description => "test ")
          expect(response).to be_successful
        end
      end

      context "with INvalid credit card" do
        let(:card_number) { "4000000000000069"} #expired card
        let(:response) { StripeWrapper::Charge.create(:amount => 99, :currency => "usd", :card => token)  }

        it "does not charge the card ", :vcr do
          expect(response).to_not be_successful
        end

        it "returns an error message ", :vcr do
          expect(response.error_message).to be_present
        end


      end
    end  
  end
end
