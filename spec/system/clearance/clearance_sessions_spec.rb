require 'rails_helper'

RSpec.describe 'Clearance::Sessions', type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  context 'new' do
    it 'correctly renders sign in page' do
      visit sign_in_path

      within 'div#clearance.sign-in' do
        form = find("form[action=\"#{session_path}\"][method=\"post\"]")

        expect(page).to have_selector('h2', text: 'Sign in', count: 1, above: form)

        within form do
          email_label    = find('label[for="session_email"]', text: 'Email')
          email_field    = find_field('session[email]', type: 'email', below: email_label)
          password_label = find('label[for="session_password"]', text: 'Password', below: email_field)
          password_field = find_field('session[password]', type: 'password', below: password_label)
          submit_button  = find_button('Sign in', below: password_field)

          expect(page).to have_link('Forgot password?', href: new_password_path, count: 1, below: submit_button)
          expect(page).to have_link('Sign up', href: sign_up_path, count: 1, below: submit_button)
        end
      end
    end
  end
end
