require 'spec_helper'

describe Admin::PaymentsController do

  let(:rick) {current_user} 
    
  describe 'GET index' do

    it_behaves_like "require_sign_in" do
      let(:action) {get :index}
    end

    it "lists the payments" do
      set_current_user
      set_current_admin
      Fabricate(:payment)
      get :index
      assigns(:payments).first.should be_instance_of(Payment)
    end
  end


end
