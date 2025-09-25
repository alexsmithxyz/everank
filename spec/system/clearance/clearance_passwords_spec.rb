require 'rails_helper'

RSpec.describe 'Clearance::Passwords', type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  context 'new' do
    it 'correctly renders reset password form' do
      visit new_password_path

      within 'div#clearance.password-reset' do
        h2 = find('h2', text: 'Reset your password')

        p_element = find('p', text: <<~TEXT.squish, below: h2)
          To be emailed a link to reset your password, please enter your email address.
        TEXT

        form = find("form[action=\"#{passwords_path}\"][method=\"post\"]", below: p_element)

        within form do
          email_label = find('label[for="password_email"]', text: 'Email address')
          email_field = find_field('password[email]', type: 'email', below: email_label)

          expect(page).to have_button('Reset password', count: 1, below: email_field)
        end
      end
    end
  end

  context 'edit' do
    it 'correctly renders change password form' do
      user = create :user
      user.forgot_password!

      visit edit_user_password_path(user, token: user.confirmation_token)

      within 'div#clearance.password-reset' do
        h2 = find('h2', text: 'Change your password')

        p_element = find('p', text: <<~TEXT.squish, below: h2)
          Your password has been reset. Choose a new password below.
        TEXT

        form_selector =
          "form[action=\"#{user_password_path(user, token: user.confirmation_token)}\"][method=\"post\"]"

        within form_selector, below: p_element do
          password_label = find('label[for="password_reset_password"]', text: 'Choose password')
          password_field = find_field('password_reset[password]', type: 'password', below: password_label)

          expect(page).to have_button('Save this password', count: 1, below: password_field)
        end
      end
    end
  end
end
