require 'spec_helper'

describe UserSignUp do
  describe '#sign_up' do

    context "the user sign up via an invitation is valid" do

      let(:hank)  { Fabricate(:user) }
      let(:customer) {double('customer', successful?: true)}
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      it "creates a follower for the inviter" do
        invitation = Fabricate(:invitation, inviter: hank)
        UserSignUp.new(Fabricate.build(:user)).sign_up({invitation_token: invitation.token})
        expect(hank.followers.count).to eq(1)
      end
      it "creates a follower for the invitee" do
        invitation = Fabricate(:invitation, inviter: hank)
        UserSignUp.new(Fabricate.build(:user)).sign_up({invitation_token: invitation.token})
        expect(hank.leaders.count).to eq(1)
      end

      it "expires the invitation token" do
        invitation = Fabricate(:invitation, inviter: hank)
        old_token = invitation.token
        UserSignUp.new(Fabricate.build(:user)).sign_up({invitation_token: invitation.token})
        expect(invitation.reload.token).to_not eq(old_token)
      end     
    end

    context "the user sign up is valid but the card is invalid" do
      let(:customer) {double('customer', successful?: false, error_message: "Your card was declined" )}
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignUp.new(Fabricate.build(:user)).sign_up({amount: 3, stripeToken: "something"})
      end

      it "does NOT generate a user" do
        User.count.should == 0
      end

    end


    context "the user sign up is valid and the card is valid" do
   
      let(:customer) {double('customer', successful?: true)}

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
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

      it "does NOT create a subscription" do
        StripeWrapper::Customer.should_not_receive(:create)
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


