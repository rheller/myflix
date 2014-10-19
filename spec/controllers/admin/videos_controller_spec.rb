require 'spec_helper'

describe Admin::VideosController do

  let(:rick) {current_user} 
    
  describe 'GET new' do

    it_behaves_like "require_sign_in" do
      let(:action) {get :new}
    end

    it_behaves_like "require_sign_in" do
      let(:action) {get :new}
    end

    it "generates a new record" do
      set_current_user
      set_current_admin
      get :new
      assigns(:video).should be_instance_of(Video)
    end
  end


    describe 'POST create' do

    it_behaves_like "require_sign_in" do
      let(:action) {post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) {post :create }
    end

    context "with INvalid data" do
      before do
          set_current_admin
          post :create, video: {description: "a farmers tale" }
      end
      it "does not saves the record" do
        Video.count.should == 0
      end

      it "renders the page" do
        response.should render_template 'new'
      end
      it "sets the ERROR notice" do
        flash[:error].should_not be_blank
      end
    end



    context "with valid data" do
      before do
          set_current_admin
          category = Fabricate(:category)
          post :create, video: {title: "great one", description: "a farmers tale", category_id: category.id }
      end

      it "saves the record" do
        Video.count.should == 1
      end

      it "redirects to video" do
        response.should redirect_to new_admin_video_path
      end

      it "sets the notice" do
        flash[:notice].should_not be_blank
      end

    end


    

    end


end
