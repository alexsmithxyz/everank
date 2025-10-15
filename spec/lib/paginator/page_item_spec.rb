require 'rails_helper'

RSpec.describe Paginator::PageItem do
  shared_examples 'general PageItem method specs' do
    let(:pagination) do
      Paginator.new(count: count, current_page: current_page, per_page: per_page)
    end

    # `pagination.items` is a representation of the page items presented to the
    # user in pagination. the first item is always the previous page, the
    # second is always page one, the second to last is always the last page,
    # the last is always the next page.
    let(:previous_page) { pagination.items.first }
    let(:first_page) { pagination.items.second }
    let(:last_page) { pagination.items.second_to_last }
    let(:next_page) { pagination.items.last }
    let(:middle_pages) { pagination.items[2..-3] }

    describe '#number' do
      it 'is set correctly' do
        expect(previous_page.number).to eq(pagination.current_page - 1)
        expect(first_page.number).to eq(1)

        item_range.each.with_index do |n, i|
          expect(middle_pages[i].number).to eq(n)
        end

        expect(last_page.number).to eq(pagination.total_pages)
        expect(next_page.number).to eq(pagination.current_page + 1)
      end
    end

    describe '#label' do
      it 'is set correctly' do
        expect(previous_page.label).to eq('<')
        expect(first_page.label).to eq(1)

        item_range.each.with_index do |n, i|
          expect(middle_pages[i].label).to eq(n)
        end

        expect(last_page.label).to eq(pagination.total_pages)
        expect(next_page.label).to eq('>')
      end
    end

    describe '#aria_label' do
      it 'is set correctly' do
        expect(previous_page.aria_label).to eq('Previous Page')

        if pagination.current_page == 1
          expect(first_page.aria_label).to eq('Current Page')
        else
          expect(first_page.aria_label).to eq('Page 1')
        end

        item_range.each.with_index do |n, i|
          current_subject = middle_pages[i]

          if current_subject.number == pagination.current_page
            expect(current_subject.aria_label).to eq('Current Page')
          else
            expect(current_subject.aria_label).to eq("Page #{n}")
          end
        end

        if pagination.current_page == pagination.total_pages
          expect(last_page.aria_label).to eq('Current Page')
        else
          expect(last_page.aria_label).to eq("Page #{pagination.total_pages}")
        end

        expect(next_page.aria_label).to eq('Next Page')
      end
    end

    describe '#responsive?' do
      it 'is true except on first, last, next and previous items' do
        pagination.items.each do |item|
          if ((pagination.current_page - 1)..(pagination.current_page + 1)).cover?(item.number) ||
             [1, pagination.total_pages].include?(item.number)
            expect(item.responsive?).to be(false)
          else
            expect(item.responsive?).to be(true)
          end
        end
      end
    end

    describe '#current?' do
      it 'is true only for the current page' do
        pagination.items.each do |item|
          expect(item.current?).to be(item.number == pagination.current_page)
        end
      end
    end

    describe '#disabled?' do
      it 'is true for the current page' do
        middle_pages.each do |item|
          expect(item.disabled?).to be(item.number == pagination.current_page)
        end
      end

      it 'is true for previous page if current page is first' do
        expect(previous_page.disabled?).to be(pagination.current_page == 1)
      end

      it 'is true for next page if current page is last' do
        expect(next_page.disabled?).to be(pagination.current_page == pagination.total_pages)
      end
    end
  end

  shared_examples 'single page pagination specs' do
    it 'has only disabled items' do
      pagination.items.each do |item|
        expect(item.disabled?).to be(true)
      end
    end

    it 'only has previous, current and next items' do
      expect(pagination.items.size).to eq(3)
      expect(pagination.items.first.label).to eq('<')
      expect(pagination.items.second.current?).to be(true)
      expect(pagination.items.second.number).to eq(pagination.current_page)
      expect(pagination.items.last.label).to eq('>')
    end
  end

  # `item_range` represents the expected pagination items other than first, last, previous and next
  context 'large series' do
    let(:count) { 500 }
    let(:per_page) { 20 }

    context 'middle' do
      let(:current_page) { 12 }
      let(:item_range) { 9..15 }

      include_examples 'general PageItem method specs'
    end

    context 'start' do
      let(:current_page) { 1 }
      let(:item_range) { 2..4 }

      include_examples 'general PageItem method specs'
    end

    context '1 from start' do
      let(:current_page) { 2 }
      let(:item_range) { 2..5 }

      include_examples 'general PageItem method specs'
    end

    context '2 from start' do
      let(:current_page) { 3 }
      let(:item_range) { 2..6 }

      include_examples 'general PageItem method specs'
    end

    context '3 from start' do
      let(:current_page) { 4 }
      let(:item_range) { 2..7 }

      include_examples 'general PageItem method specs'
    end

    context '4 from start' do
      let(:current_page) { 5 }
      let(:item_range) { 2..8 }

      include_examples 'general PageItem method specs'
    end

    context '5 from start' do
      let(:current_page) { 6 }
      let(:item_range) { 3..9 }

      include_examples 'general PageItem method specs'
    end

    context 'end' do
      let(:current_page) { 25 }
      let(:item_range) { 22..24 }

      include_examples 'general PageItem method specs'
    end

    context '1 from end' do
      let(:current_page) { 24 }
      let(:item_range) { 21..24 }

      include_examples 'general PageItem method specs'
    end

    context '2 from end' do
      let(:current_page) { 23 }
      let(:item_range) { 20..24 }

      include_examples 'general PageItem method specs'
    end

    context '3 from end' do
      let(:current_page) { 22 }
      let(:item_range) { 19..24 }

      include_examples 'general PageItem method specs'
    end

    context '4 from end' do
      let(:current_page) { 21 }
      let(:item_range) { 18..24 }

      include_examples 'general PageItem method specs'
    end

    context '5 from end' do
      let(:current_page) { 20 }
      let(:item_range) { 17..23 }

      include_examples 'general PageItem method specs'
    end
  end

  context 'small series' do
    context '7 pages' do
      let(:count) { 65 }
      let(:per_page) { 10 }

      context 'page 4' do
        let(:current_page) { 4 }
        let(:item_range) { 2..6 }

        include_examples 'general PageItem method specs'
      end
    end

    context '6 pages' do
      let(:count) { 55 }
      let(:per_page) { 10 }

      context 'page 3' do
        let(:current_page) { 3 }
        let(:item_range) { 2..5 }

        include_examples 'general PageItem method specs'
      end
    end

    context '5 pages' do
      let(:count) { 45 }
      let(:per_page) { 10 }

      context 'page 2' do
        let(:current_page) { 3 }
        let(:item_range) { 2..4 }

        include_examples 'general PageItem method specs'
      end
    end

    context '4 pages' do
      let(:count) { 35 }
      let(:per_page) { 10 }

      context 'page 2' do
        let(:current_page) { 2 }
        let(:item_range) { 2..2 }

        include_examples 'general PageItem method specs'
      end
    end

    context '3 pages' do
      let(:count) { 25 }
      let(:per_page) { 10 }

      context 'page 2' do
        let(:current_page) { 2 }
        let(:item_range) { 2..2 }

        include_examples 'general PageItem method specs'
      end
    end

    context '2 pages' do
      let(:count) { 15 }
      let(:per_page) { 10 }

      context 'page 1' do
        let(:current_page) { 1 }
        let(:item_range) { 2..1 }

        include_examples 'general PageItem method specs'
      end
    end

    context '1 page' do
      let(:count) { 5 }
      let(:per_page) { 10 }

      context 'page 1' do
        let(:current_page) { 1 }
        let(:item_range) { 2..1 }

        include_examples 'general PageItem method specs'
        include_examples 'single page pagination specs'
      end
    end
  end

  context 'no records' do
    let(:pagination) do
      Paginator.new(count: 0, current_page: 1, per_page: 10)
    end

    include_examples 'single page pagination specs'
  end
end
