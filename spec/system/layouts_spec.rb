require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  context 'application' do
    describe 'header content' do
      context 'signed out' do
        before do
          visit root_path
        end

        it 'is layed out horizontally' do
          within 'header nav' do
            sign_up_link = find_link 'Sign up', href: sign_up_path
            sign_in_link = find_link 'Sign in', href: sign_in_path, left_of: sign_up_link
            expect(page).to have_link('Everank', href: root_path, left_of: sign_in_link)
          end
        end
      end

      context 'signed in' do
        let(:user) { create :user }

        before do
          visit root_path(as: user)
        end

        it 'is layed out horizontally' do
          within 'header nav' do
            sign_out_button = find_button 'Sign out'
            p_tag = find 'p', text: "Signed in as: #{user.email}", left_of: sign_out_button
            expect(page).to have_link('Everank', href: root_path, left_of: p_tag)
          end
        end
      end
    end
  end
end
