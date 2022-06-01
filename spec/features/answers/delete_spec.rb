require 'rails_helper'

feature 'User can delete his answer' do
  given(:question) { create(:question, user: user) }
  given(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'User tries to delete his answer' do
    answer = create(:answer, question: question, user: user )
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario "User tries to delete someone else's answer" do
    another_user = create(:user)
    answer = create(:answer, question: question, user: another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
