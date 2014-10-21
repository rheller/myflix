require 'spec_helper'


feature 'admin enters new video, user watches it' do

  background do
    @mystery = Fabricate(:category)
  end

  scenario 'new video entered correctly' do
    rick = Fabricate(:admin)
    sign_in(rick)
    visit new_admin_video_path
    expect(page).to have_content "Add a New Video"

    fill_in 'Title', :with => 'Moulin rouge'
    fill_in 'Description', :with => 'Takes place in Paris'
    select @mystery.name, from: 'Category'
    attach_file "Large cover", 'spec/support/uploads/monk_large.jpg'
    attach_file "Small cover", 'spec/support/uploads/monk.jpg'
    fill_in 'Video URL', :with => 'https://www.youtube.com/test'
    click_button "Add Video"
    expect(page).to have_content "Video has been saved"
    sign_out

    joe = Fabricate(:user)
    sign_in(joe)
    visit videos_path
    find("a[href='/videos/1']").click
    expect(page).to have_selector("img[src='/uploads/video/large_cover/1/monk_large.jpg']")
    expect(page).to have_selector("a[href='https://www.youtube.com/test']")

  end

end
