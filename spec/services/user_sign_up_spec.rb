require 'spec_helper'

describe UserSignUp do
  describe '#sign_up' do
    context "the user sign up is valid and the card is valid" do
   
      let(:charge) {double('charge', successful?: true)}

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserSignUp.new(Fabricate.build(:user)).sign_up({amount: 3, stripeToken: "something"})
      end

      after do
        #unlike the test database, RSpec does not automatically clear the mail queue
        ActionMailer::Base.deliveries.clear
      end

      it "generates a user from valid data" do
        User.count.should == 1
      end

      it "sends a welcome email " do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      
      it "checks if the email is addressed to the right person" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["rick.heller@yahoo.com"])
      end

      it "has the correct content" do
        expect(ActionMailer::Base.deliveries.last.body).to include("Welcome")
      end

    end

    context "the user sign up is INVALID" do
      before do
        ActionMailer::Base.deliveries.clear
        UserSignUp.new(User.new({email: "", password: "", full_name: ""})).sign_up({amount: 3, stripeToken: "something"})
      end
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "does NOT generate charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end
      it "does NOT generate a user" do
        User.count.should == 0
      end
      it "DOES NOT send a welcome email " do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
   end

  end
end


