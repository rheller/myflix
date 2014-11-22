require 'spec_helper'


feature 'new user registration' do

   background do
    # will clear the message queue
    clear_emails
  end

  let('user_email')  { 'Jamie@rickheller.com' }

  scenario 'user enters a valid email address', {js: true, vcr: true} do




    visit root_path
    click_link('Sign Up')

    expect(page).to have_content 'Register'
    fill_in "Password", with: 'gonzo'
    fill_in "Full Name", with: "Jamie Smil"
    fill_in "Email", with: user_email
    fill_in "card_number", with: "4242 4242 4242 4242"
    fill_in "cvc", with: "123"
    fill_in "exp-month", with: "3"
    fill_in "exp-year", with: "2017"
    click_button "Sign Up"
    expect(page).to have_content 'Sign In'


    user_signs_in(user_email)    
    click_link('People')
    expect(page).to have_content "Jamie Smil"
    sign_out("Jamie Smil")    
    clear_email
  end
#########################################

  def user_signs_in(user_email)
    fill_in "email", with: user_email
    fill_in "password", with: 'gonzo'
    click_button "Sign In"
    expect(page).to have_content "Welcome, " + "Jamie Smil"
  end

end
