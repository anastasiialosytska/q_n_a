require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }

  scenario 'Unauthenticated user can not edit question' do
    question = create(:question, user: user)
    visit question_path(question)

    expect(page).to_not have_link('Edit question')
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'tries to edit his question' do
      question = create(:question, user: user)
      visit question_path(question)
      click_on 'Edit question'

      fill_in 'Title', with: 'New question title'
      fill_in 'Body', with: 'New question body'
      click_on 'Save'

      expect(page).to have_content 'New question title'
      expect(page).to have_content 'New question body'
    end

    scenario 'tries to edit his question with errors' do
      question = create(:question, user: user)
      visit question_path(question)
      click_on 'Edit question'

      fill_in 'Title', with: nil
      fill_in 'Body', with: nil
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to attach files' do
      question = create(:question, user: user)
      visit question_path(question)
      click_on 'Edit question'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'tries to delete attached files' do
      question = create(:question, user: user)
      visit question_path(question)
      click_on 'Edit question'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Save'

      within '.question' do
        click_on 'Delete'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario "tries to edit someone else's question" do
      another_user = create(:user)
      question = create(:question, user: another_user)
      visit question_path(question)

      expect(page).to_not have_content 'Edit question'
    end
  end
end
