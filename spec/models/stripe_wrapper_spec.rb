require 'spec_helper'

describe StripeWrapper do 
  describe StripeWrapper::Charge do
    describe ".create" do
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
        it "charges the card successfully", :vcr do
          response = StripeWrapper::Charge.create( :amount => 100, :currency => "usd", :card => token, :description => "test ")
  puts response.inspect
          expect(response).to be_successful
        end
      end

      context "with INvalid credit card" do
        let(:card_number) { "4000000000000069"} #expired card
        let(:response) { StripeWrapper::Charge.create(:amount => 100, :currency => "usd", :card => token)  }

        it "does NOT charge the card ", :vcr do
          expect(response).to_not be_successful
        end

        it "returns an error message ", :vcr do
          expect(response.error_message).to eq("Your card has expired.")
        end
      end
    end  
  end
end
