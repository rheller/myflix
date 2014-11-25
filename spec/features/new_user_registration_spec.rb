require 'spec_helper'


feature 'new user registration' do

   background do
    # will clear the message queue
    clear_emails
  end

  let('valid_email')  { 'Jamie@rickheller.com' }
  let('invalid_email')  { '' }
  let('user_password')  { 'password' }
  let('user_full_name')  { 'Jamie Smil' }
  let ('valid_card_number') {"4242 4242 4242 4242"}
  let ('invalid_card_number') {"5566"}
  let ('success_message') {'Thank you for registering. Please sign in.'}
  let ('invalid_card_message') {'This card number looks invalid'}
  let ('invalid_user_message') {'The user information looks invalid.'}

  scenario 'user enters a valid credit card and valid email', {js: true, vcr: true} do
    user_enters_info(valid_card_number, valid_email)
    expect(page).to have_content success_message
    expect(User.count).to eq(1)
  end

  scenario 'user enters a valid credit card and invalid email', {js: true, vcr: true} do
    user_enters_info(valid_card_number, invalid_email)
    expect(page).to have_content invalid_user_message
    expect(User.count).to eq(0)
  end

  scenario 'user enters a INvalid credit card and valid email', {js: true, vcr: true} do
    user_enters_info(invalid_card_number, valid_email)
    expect(page).to have_content invalid_card_message
    expect(User.count).to eq(0)
  end

  scenario 'user enters a INvalid credit card and invalid email', {js: true, vcr: true} do
    user_enters_info(invalid_card_number, invalid_email)
    expect(page).to have_content invalid_card_message
    expect(User.count).to eq(0)
  end



#########################################

  def user_enters_info(card_number, email)
    visit root_path
    click_link('Sign Up')
    expect(page).to have_content 'Register'
    fill_in "Password", with: user_password
    fill_in "Full Name", with: user_full_name
    fill_in "Email", with: email
    fill_in "card_number", with: card_number
    fill_in "cvc", with: "123"
    fill_in "exp-month", with: "3"
    fill_in "exp-year", with: "2017"
    click_button "Sign Up"
end


  def user_signs_in(user_email)
    fill_in "email", with: user_email
    fill_in "password", with: user_password
    click_button "Sign In"
    expect(page).to have_content "Welcome, " + user_full_name
  end

end
