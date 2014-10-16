require 'spec_helper'

describe Admin::VideosController do

  let(:rick) {current_user} 
    
  describe 'GET new' do

    it_behaves_like "require_sign_in" do
      let(:action) {get :new}
    end

    it "redirects with no admin access" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end

    it "generates a new record" do
      set_current_user
      set_current_admin
      get :new
      assigns(:video).should be_instance_of(Video)
    end
  end


    describe 'POST create' do
   
      it "redirects with no admin access"
      it "returns an error with invalid data"

   #with valid data
      before do
          set_current_admin
          post :create, video: {title: "great one", description: "a farmers tale" }
      end

      it "saves the record" do
        Video.count.should == 1
      end

      it "redirects to video" do
        response.should redirect_to root_path
      end

      it "sets the notice" do
        flash[:notice].should_not be_blank
      end

    end


end
