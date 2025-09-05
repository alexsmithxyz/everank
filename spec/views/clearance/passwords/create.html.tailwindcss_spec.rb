require 'rails_helper'

RSpec.describe 'passwords/create', type: :view do
  it 'renders change password submitted' do
    render

    expect(rendered).to have_selector('div#clearance.password-reset', count: 1) do |container|
      expect(container).to have_selector('p', text: <<~TXT.squish, count: 1)
        You will receive an email within the next few minutes.
        It contains instructions for changing your password.
      TXT
    end
  end
end
