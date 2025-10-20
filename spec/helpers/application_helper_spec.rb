require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '#error_explanation' do
    context 'invalid title' do
      let(:invalid_title) { Title.new.tap(&:valid?) }

      it 'wraps content in div with id' do
        expect(error_explanation(invalid_title)).to have_selector('div#error-explanation')
      end

      it 'contains an h3 with correct content' do
        expect(error_explanation(invalid_title)).to have_selector('h3', text: '1 error prohibited this title from being saved:')
      end

      it 'contains the correct number of list items' do
        expect(error_explanation(invalid_title)).to have_selector('ul li', count: 1)
      end

      it 'contains list items with correct content' do
        expect(error_explanation(invalid_title)).to have_selector('ul li', text: "Name can't be blank")
      end
    end

    context 'invalid user' do
      let(:invalid_user) { User.new.tap(&:valid?) }

      it 'wraps content in div with id' do
        expect(error_explanation(invalid_user)).to have_selector('div#error-explanation')
      end

      it 'contains an h3 with correct content' do
        expect(error_explanation(invalid_user)).to have_selector('h3', text: '4 errors prohibited this user from being saved:')
      end

      it 'contains the correct number of list items' do
        expect(error_explanation(invalid_user)).to have_selector('ul li', count: 4)
      end

      it 'contains list items with correct content' do
        expect(error_explanation(invalid_user)).to have_selector('ul li', text: 'Email is invalid')
        expect(error_explanation(invalid_user)).to have_selector('ul li', text: "Email can't be blank")
        expect(error_explanation(invalid_user)).to have_selector('ul li', text: "Password can't be blank")
        expect(error_explanation(invalid_user)).to have_selector('ul li', text: 'Password is too short (minimum is 8 characters)')
      end
    end
  end
end
