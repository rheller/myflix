require 'spec_helper'


feature 'user signs in' do

  scenario 'with existing username' do
    rick = Fabricate(:user)
    sign_in(rick)
    expect(page).to have_content "Welcome, " + rick.full_name
  end

  scenario 'with existing username to locked account' do
    rick = Fabricate(:user, locked: true)
    sign_in(rick)
    expect(page).to_not have_content "Welcome, " + rick.full_name
    expect(page).to have_content "Sign In"
  end




scenario 'with INVALID username' do
    @rick = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: @rick.email + 'X'
    fill_in "Password", with: @rick.password + 'X'
    click_button "Sign In"
    expect(page).to have_content "Sign In"
  end


end
