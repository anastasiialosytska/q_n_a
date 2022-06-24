require 'rails_helper'

feature 'User can delete his answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  background { sign_in(user) }

  scenario 'User tries to delete his answer', js: true do
    answer = create(:answer, question: question, user: user )
    visit question_path(question)

    within '.answers' do
      click_on 'Delete'

      expect(page).to_not have_content answer.body
    end
  end

  scenario "User tries to delete someone else's answer" do
    another_user = create(:user)
    answer = create(:answer, question: question, user: another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
