require 'rails_helper'

RSpec.describe Title, type: :model do
  describe 'validations' do
    context 'name' do
      it 'is required' do
        title = build(:title, name: nil)
        expect(title).not_to be_valid
        expect(title.errors[:name]).to include("can't be blank")
      end
    end
  end
end
