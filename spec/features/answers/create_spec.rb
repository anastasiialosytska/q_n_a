require 'rails_helper'

feature 'User can write an answer to the question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user gives an answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Reply'

    expect(page).to have_content 'Your answer successfully added'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user gives an answer with errors' do
    sign_in(user)
    visit question_path(question)

    click_on 'Reply'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user tries to gives an answer' do
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end