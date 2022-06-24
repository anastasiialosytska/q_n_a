require 'rails_helper'

feature "User can choose the best answer", %q{
  As an author of question
  I'd like to be able to choose the best answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not choose the best answer' do
    create(:answer, question: question, user: user)
    visit question_path(question)

    expect(page).to_not have_link('Best answer')
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'choose the best answer to the question', js: true do
      create_list(:answer, 3, question: question, user: user)
      best_answer = create(:answer, question: question, user: user)
      visit question_path(question)
      page.find_by_id("best-answer-#{best_answer.id}").click
      
      expect(find(".answer", match: :first)).to have_content best_answer.body
    end

    scenario "tries to choose the best answer to other user's question" do
      create(:answer, question: question, user: user)
      another_user = create(:user)
      question = create(:question, user: another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end
end
