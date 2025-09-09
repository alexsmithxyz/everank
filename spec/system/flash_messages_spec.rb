require 'rails_helper'

RSpec.describe "FlashMessages", type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  it 'dismisses flash messages via the button' do
    visit sign_in_path

    click_button 'Sign in'

    expect(page).to have_css('.flash.alert')

    click_button '×'

    expect(page).not_to have_css('.flash.alert')
  end
end
