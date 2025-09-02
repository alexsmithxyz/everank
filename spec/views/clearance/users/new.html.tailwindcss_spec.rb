require 'rails_helper'

RSpec.describe 'users/new', type: :view do
  it 'renders new user form' do
    @user = User.new
    render

    expect(rendered).to have_selector('div#clearance.sign-up', count: 1) do |container|
      expect(container).to have_selector('h2', text: 'Sign up', count: 1)

      form_selector = "form[action=\"#{users_path}\"][method=\"post\"]"

      expect(container).to have_selector(form_selector, count: 1) do |form|
        expect(form).to have_field('user[email]', type: 'email', count: 1)
        expect(form).to have_field('user[password]', type: 'password', count: 1)
        expect(form).to have_button('Sign up', count: 1)
      end

      expect(container).to have_link('Sign in', href: sign_in_path, count: 1)
    end
  end
end
