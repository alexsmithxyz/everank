require 'rails_helper'

RSpec.describe TitlePolicy, type: :policy do
  subject { described_class }

  let(:no_user) { nil }
  let(:ordinary_user) { create(:user, role: :ordinary_user) }
  let(:admin) { create(:user, role: :admin) }
  let(:title) { build(:title) }

  permissions :index?, :show? do
    it 'grants access to those not signed in' do
      expect(subject).to permit(no_user, title)
    end

    it 'grants access to ordinary users' do
      expect(subject).to permit(ordinary_user, title)
    end

    it 'grants access to admins' do
      expect(subject).to permit(admin, title)
    end
  end

  permissions :create?, :update?, :destroy? do
    it 'denies access to those not signed in' do
      expect(subject).not_to permit(no_user, title)
    end

    it 'denies access to ordinary users' do
      expect(subject).not_to permit(ordinary_user, title)
    end

    it 'permits access to admins' do
      expect(subject).to permit(admin, title)
    end
  end
end
