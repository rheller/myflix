require 'spec_helper'


feature 'new user registration' do

   background do
    # will clear the message queue
    clear_emails
  end

  let('user_email')  { 'Jamie@rickheller.com' }
  let('user_password')  { 'gonzo1' }
  let('user_full_name')  { 'Jamie Smil' }
  let ('valid_card_number') {"4242 4242 4242 4242"}

  scenario 'user enters a valid email address', {js: true, vcr: true} do


    visit root_path
    click_link('Sign Up')

    expect(page).to have_content 'Register'
    fill_in "Password", with: user_password
    fill_in "Full Name", with: user_full_name
    fill_in "Email", with: user_email
    fill_in "card_number", with: valid_card_number
    fill_in "cvc", with: "123"
    fill_in "exp-month", with: "3"
    fill_in "exp-year", with: "2017"
    click_button "Sign Up"
    expect(page).to have_content 'Sign In'


    user_signs_in(user_email)    
    click_link('People')
    expect(page).to have_content user_full_name
    sign_out(user_full_name)    
    clear_email
  end
#########################################

  def user_signs_in(user_email)
    fill_in "email", with: user_email
    fill_in "password", with: user_password
    click_button "Sign In"
    expect(page).to have_content "Welcome, " + user_full_name
  end

end
