require 'rails_helper'

RSpec.describe 'passwords/edit', type: :view do
  it 'renders change password form' do
    @user = create :user
    @user.forgot_password!

    render

    expect(rendered).to have_selector('div#clearance.password-reset', count: 1) do |container|
      expect(container).to have_selector('h2', text: 'Change your password', count: 1)

      expect(container).to have_selector('p', text: <<~TXT.strip, count: 1)
        Your password has been reset. Choose a new password below.
      TXT

      form_selector = "form[action=\"#{user_password_path(@user, token: @user.confirmation_token)}\"][method=\"post\"]"

      expect(container).to have_selector(form_selector, count: 1) do |form|
        expect(form).to have_field('password_reset[password]', type: 'password', count: 1)
        expect(form).to have_button('Save this password', count: 1)
      end
    end
  end
end
