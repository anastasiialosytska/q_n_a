require 'rails_helper'

feature 'User can register', %q{
  In order to use application
  With full functionality
  I'd like to be able to register
} do

  background { visit new_user_registration_path }

  scenario 'User tries to register with valid data' do
    fill_in 'Email', with: 'test_email@qna.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to register without email' do
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'User tries to register without password' do
    fill_in 'Email', with: 'test_email@qna.com'
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'User tries to register without password' do
    fill_in 'Email', with: 'test_email@qna.com'
    fill_in 'Password', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
