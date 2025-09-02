require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'email' do
      it 'is required' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'must be unique' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end

      it 'must have valid format' do
        user = build(:user, email: 'invalid email')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    context 'password' do
      it 'is required on creation' do
        user = build(:user, password: nil)
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'must be at least 8 characters' do
        user = build(:user, password: '1234567')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
      end

      it 'accepts valid password' do
        user = build(:user, password: 'password')
        expect(user).to be_valid
      end
    end
  end

  describe 'authentication' do
    it 'authenticates with correct credentials' do
      user = create(:user, email: 'test@example.com', password: 'password')
      expect(User.authenticate('test@example.com', 'password')).to eq(user)
    end

    it 'does not authenticate with wrong password' do
      create(:user, email: 'test@example.com', password: 'password')
      expect(User.authenticate('test@example.com', 'wrongpassword')).to be_nil
    end
  end
end
