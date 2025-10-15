require 'rails_helper'

class DummyModel < ActiveRecord::Base
  include Pagination

  self.table_name = 'dummies'
end

RSpec.describe Pagination, type: :concern do
  before(:all) do
    DummyModel.connection.create_table :dummies, temporary: true do |t|
      t.string :name
    end

    DummyModel.create!(Array.new(40) { |i| { name: "Dummy #{i}" } })
  end

  describe '#paginate' do
    let(:per_page) { 10 }
    let(:current_page) { 2 }

    subject { DummyModel.paginate(per_page: per_page, current_page: current_page) }

    it 'returns a paginator' do
      expect(subject.first).to be_a(Paginator)
    end

    it 'passes per_page correctly to paginator' do
      expect(subject.first.per_page).to eq(per_page)
    end

    it 'passes current_page correctly to paginator' do
      expect(subject.first.current_page).to eq(current_page)
    end

    it 'passes correct count to paginator' do
      expect(subject.first.count).to eq(DummyModel.count)
    end

    it 'returns active record collection' do
      expect(subject.second).to be_an(ActiveRecord::Relation)
    end

    it 'returns collection of correct size' do
      expect(subject.second.length).to eq(per_page)
    end

    it 'specifies offset using current page' do
      DummyModel.all[10..19].each do |dummy|
        expect(subject.second).to include(dummy)
      end
    end

    it "doesn't include records outside of specified page" do
      DummyModel.all[0..9].each do |dummy|
        expect(subject.second).not_to include(dummy)
      end

      DummyModel.all[20..].each do |dummy|
        expect(subject.second).not_to include(dummy)
      end
    end
  end

  after(:all) do
    DummyModel.connection.drop_table :dummies if DummyModel.connection.table_exists?(:dummies)
  end
end
