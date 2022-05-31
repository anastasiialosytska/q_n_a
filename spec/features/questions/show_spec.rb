require 'rails_helper'

feature 'Any user can view question and answers' do
  given(:question) { create(:question) }

  scenario 'Authenticated user can view the question and answers' do
    user = create(:user)
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content "#{question.title}"
    expect(page).to have_content "#{question.body}"
    expect(page).to have_content 'List of answers'
  end

  scenario 'Unauthenticated user can view the question and answers' do
    visit question_path(question)

    expect(page).to have_content "#{question.title}"
    expect(page).to have_content "#{question.body}"
    expect(page).to have_content 'List of answers'
  end
end
