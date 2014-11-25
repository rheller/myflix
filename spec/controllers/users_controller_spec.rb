require 'spec_helper'

describe UsersController do

  let(:hank)  { Fabricate(:user) }

#######################################################

  describe 'GET show' do
    it_behaves_like "require_sign_in" do
      let(:action) {get :show, id: 1}
    end

    it "prepares the user instance variable" do
      set_current_user(hank)
      get :show, id: hank.id
      expect(assigns(:user)).to eq(hank)
      end
  end

#######################################################
  describe 'GET new_with_invitation_token' do

  context "the token is valid" do 
    it "renders new" do
      invitation = Fabricate(:invitation, inviter: hank)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "fills in the invitees email with valid token" do
      #invitation = Invitation.create(recipient_email: 'rick.heller@yahoo.com', recipient_name: 'Joe', message: 'hi', inviter: hank)
      invitation = Fabricate(:invitation, inviter: hank)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
  end

  
  it "redirects with INvalid token" do
    get :new_with_invitation_token, token: "fake"
    expect(response).to redirect_to invalid_token_path
  end

end
#######################################################
  describe 'GET new' do
    it "generates a new record" do
      get :new
      assigns(:user).should be_instance_of(User)
    end
  end


#######################################################
  describe 'POST create' do

    context "successful user sign up" do
   
      it "redirects to sign_in" do
        result = double(:sign_up_result, successful?: true)
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        response.should redirect_to sign_in_path
      end

    end

    context "the user sign up is INVALID" do
      it "rerenders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "It failed")
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to render_template 'new'
      end

      it "sets the flash message" do
        result = double(:sign_up_result, successful?: false, error_message: "It failed")
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:error]).to eq("It failed")
      end

    end

  end
##############################################

end
