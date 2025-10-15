require 'rails_helper'

RSpec.describe Paginator do
  subject { described_class.new(count: 1000, current_page: 25, per_page: 20) }

  describe '#initialize' do
    it 'sets count' do
      expect(subject.count).to eq(1000)
    end

    it 'sets current_page' do
      expect(subject.current_page).to eq(25)
    end

    it 'sets per_page' do
      expect(subject.per_page).to eq(20)
    end

    it 'sets total_pages' do
      expect(subject.total_pages).to eq(50)
    end

    it 'sets items' do
      expect(subject.items).to all(be_a(Paginator::PageItem))
      expect(subject.items.size).to eq(11)
    end

    it 'sets unresponsive_items' do
      expect(subject.unresponsive_items).to be_a(Array)
      expect(subject.unresponsive_items.size).to eq(7)
      expect(subject.unresponsive_items.first).to eq(:prev)
      expect(subject.unresponsive_items.second).to eq(1)
      expect(subject.unresponsive_items[2..-3]).to eq([ 24, 25, 26 ])
      expect(subject.unresponsive_items.second_to_last).to eq(50)
      expect(subject.unresponsive_items.last).to eq(:next)
    end
  end
end
