require 'rails_helper'

RSpec.describe 'sessions/new', type: :view do
  it 'renders sign in page' do
    render

    expect(rendered).to have_selector('div#clearance.sign-in', count: 1) do |container|
      expect(container).to have_selector('h2', text: 'Sign in', count: 1)

      form_selector = "form[action=\"#{session_path}\"][method=\"post\"]"

      expect(container).to have_selector(form_selector, count: 1) do |form|
        expect(form).to have_field('session[email]', type: 'email', count: 1)
        expect(form).to have_field('session[password]', type: 'password', count: 1)
        expect(form).to have_button('Sign in', count: 1)
      end

      expect(container).to have_link('Forgot password?', href: new_password_path, count: 1)
      expect(container).to have_link('Sign up', href: sign_up_path, count: 1)
    end
  end
end
