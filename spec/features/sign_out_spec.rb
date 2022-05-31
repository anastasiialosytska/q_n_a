require 'rails_helper'

feature 'User can sign out', %q{
  In order to finished current session
  As an authorized user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authorized user tries to sign out' do
    click_on 'Log out'

    expect(page).to have_content "Signed out successfully."
  end
end
