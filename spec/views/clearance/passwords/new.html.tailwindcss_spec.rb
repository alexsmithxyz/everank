require 'rails_helper'

RSpec.describe 'passwords/new', type: :view do
  it 'renders reset password form' do
    render

    expect(rendered).to have_selector('div#clearance.password-reset', count: 1) do |container|
      expect(container).to have_selector('h2', text: 'Reset your password', count: 1)

      expect(container).to have_selector('p', text: <<~TXT.strip, count: 1)
        To be emailed a link to reset your password, please enter your email address.
      TXT

      form_selector = "form[action=\"#{passwords_path}\"][method=\"post\"]"

      expect(container).to have_selector(form_selector, count: 1) do |form|
        expect(form).to have_field('password[email]', type: 'email', count: 1)
        expect(form).to have_button('Reset password', count: 1)
      end
    end
  end
end
