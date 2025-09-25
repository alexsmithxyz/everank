require 'rails_helper'

RSpec.describe 'Clearance::Users', type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  context 'new' do
    it 'correctly renders new user form' do
      visit sign_up_path

      within 'div#clearance.sign-up' do
        form = find("form[action=\"#{users_path}\"][method=\"post\"]")

        expect(page).to have_selector('h2', text: 'Sign up', count: 1, above: form)

        within form do
          email_label    = find('label[for="user_email"]', text: 'Email')
          email_field    = find_field('user[email]', type: 'email', below: email_label)
          password_label = find('label[for="user_password"]', text: 'Password', below: email_field)
          password_field = find_field('user[password]', type: 'password', below: password_label)
          submit_button  = find_button('Sign up', below: password_field)

          expect(page).to have_link('Sign in', href: sign_in_path, count: 1, below: submit_button)
        end
      end
    end
  end
end
