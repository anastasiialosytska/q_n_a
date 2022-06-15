require 'rails_helper'

feature 'Any user can view the list of questions' do
  scenario 'Authenticated user can view the list of questions' do
    user = create(:user)
    sign_in(user)

    visit root_path

    expect(page).to have_content 'All questions'
  end

  scenario 'Unauthenticated user can view the list of questions' do
    visit root_path

    expect(page).to have_content 'All questions'
  end
end
