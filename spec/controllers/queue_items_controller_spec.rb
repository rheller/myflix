require 'spec_helper'

describe QueueItemsController do

  context "user logged in" do


    describe "delete item" do
      before do
        @rick = Fabricate(:user)
        session[:user_id] = @rick.id
        @monk = Fabricate(:video)
        @q1   = Fabricate(:queue_item, position: 1, user: @rick)
        delete :destroy, id: @q1.id
      end

        it "renders the template" do
          response.should redirect_to my_queue_path
      end

      it "removes the item" do
        QueueItem.count.should == 0
      end

      it "repositions the items"
    end


    describe 'GET index' do
      before do
        @rick = Fabricate(:user)
        session[:user_id] = @rick.id
        @monk = Fabricate(:video)
        @conk = Fabricate(:video)
        @q1   = Fabricate(:queue_item, position: 2, user: @rick)
        @q2   = Fabricate(:queue_item, position: 1, user: @rick)
      end

        it "prepares the queue items for the current user" do
          get :index
    #puts assigns(:categories).inspect
          assigns(:queue_items).should == [@q2,@q1]
        end

        it "renders the template" do
          get :index
          response.should render_template :index
        end

      end
#####################################################
    describe 'POST create' do
      before do
        @rick = Fabricate(:user)
        session[:user_id] = @rick.id
        @monk = Fabricate(:video)
      end

      it "redirects to my queue" do
        post :create, video_id: @monk.id, user_id: @rick.id
        response.should redirect_to my_queue_path
      end

      it "updates the queue item" do
        post :create, video_id: @monk.id, user_id: @rick.id
        QueueItem.count.should == 1
      end

      it "the queue item is associated with the video" do
        post :create, video_id: @monk.id, user_id: @rick.id
        QueueItem.first.video.should == @monk
      end

      it "the queue item is associated with the user" do
        post :create, video_id: @monk.id, user_id: @rick.id
        QueueItem.first.user.should == @rick
      end

      it "the queue item is in the last position for the user" do
        @q1   = Fabricate(:queue_item, position: 1, video: @monk,  user: @rick)
        @donk = Fabricate(:video)
        post :create, video_id: @donk.id, user_id: @rick.id
        QueueItem.last.position.should == 2
      end

      it "does not create a duplicate queue item" do
        @q1   = Fabricate(:queue_item, position: 1, video: @monk,  user: @rick)
        post :create, video_id: @monk.id, user_id: @rick.id
        QueueItem.count.should == 1
      end

    end

=begin
    describe 'POST change item order' do
   
      it "updates the queue items orders" do
      end

      it "redirects to queue items" do
      #  response.should redirect_to @monk
      end

      it "sets the notice" do
        flash[:notice].should_not be_blank
      end

    end
=end

  end

  context "user NOT logged in" do

    before do
      @monk = Fabricate(:video)
    end

    describe 'get index' do
      it "renders redirect to sign_in" do
        get :index
        response.should redirect_to sign_in_path
      end
    end

    describe 'post create' do
      it "redirects to sign_in" do
        post :create
        response.should redirect_to sign_in_path
      end
    end

    describe 'delete destroy' do
      it "redirects to sign_in" do
        delete :destroy, id: 1
        response.should redirect_to sign_in_path
      end
    end

  end

end