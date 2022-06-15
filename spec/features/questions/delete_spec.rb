require 'rails_helper'

feature 'User can delete his question' do
  given(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'User tries to delete his question' do
    question = create(:question, user: user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted'
  end

  scenario "User tries to delete someone else's question" do
    another_user = create(:user)
    question = create(:question, user: another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
