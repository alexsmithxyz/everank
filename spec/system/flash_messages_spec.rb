require 'rails_helper'

RSpec.describe "FlashMessages", type: :system do
  before do
    driven_by :selenium, using: :headless_firefox

    visit sign_in_path

    click_button 'Sign in'
  end

  it 'dismisses flash messages via the button' do
    expect(page).to have_css('.flash.alert')

    click_button '×'

    expect(page).not_to have_css('.flash.alert')
  end

  it 'is layed out horizontally' do
    within '.flash.alert' do
      expect(page).to have_button('×', right_of: find('p'))
    end
  end
end
