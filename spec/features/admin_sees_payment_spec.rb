require 'spec_helper'


feature 'admin views payments' do

  background do
    Fabricate(:payment, amount: 1799)
  end

  scenario 'admin can see payments' do
    rick = Fabricate(:admin)
    sign_in(rick)
    visit admin_payments_path
    expect(page).to have_content "17.99"
  end

  scenario 'non-admin cannot see payments' do
    joe = Fabricate(:user)
    sign_in(joe)
    visit admin_payments_path
    expect(page).to_not have_content "17.99"
    expect(page).to have_content "not available"
  end

end
