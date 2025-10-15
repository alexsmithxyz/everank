require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PaginationHelper. For example:
#
# describe PaginationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PaginationHelper, type: :helper do
  let(:controller_name) { 'titles' }

  shared_examples 'general paginate specs' do
    describe '#paginate' do
      it 'contains correct wrappers' do
        expect(paginate(pagination)).to have_selector('div nav ul')
      end
    end
  end

  shared_examples 'general page item specs' do
    describe '#page_item' do
      it 'sets correct attributes for disabled page items' do
        pagination.items.select(&:disabled?).each do |item|
          expect(page_item(item)).to have_selector('a[role="link"][aria-disabled="true"]')
        end
      end

      it "doesn't contain disabled attributes on non-disabled items" do
        pagination.items.reject(&:disabled?).each do |item|
          expect(page_item(item)).to have_no_selector('a[role="link"][aria-disabled]')
        end
      end

      it 'sets correct href for non-disabled page items' do
        pagination.items.reject(&:disabled?).each do |item|
          path = url_for(controller: controller_name, action: action_name, page: item.number)
          expect(page_item(item)).to have_selector("a[href=\"#{path}\"]")
        end
      end

      it "doesn't set href on disabled items" do
        pagination.items.select(&:disabled?).each do |item|
          expect(page_item(item)).to have_no_selector('a[href]')
        end
      end

      it 'sets responsive classname on responsive item list item tags' do
        pagination.items.select(&:responsive?).each do |item|
          expect(page_item(item)).to have_selector('li[class="responsive"]')
        end
      end

      it "doesn't set responsive classname on unresponsive item list item tags" do
        pagination.items.reject(&:responsive?).each do |item|
          expect(page_item(item)).to have_no_selector('li[class="responsive"]')
        end
      end

      it 'sets aria-current only for the current page' do
        pagination.items.each do |item|
          if item.number == pagination.current_page
            expect(page_item(item)).to have_selector('a[aria-current="page"]')
          else
            expect(page_item(item)).to have_no_selector('a[aria-current="page"]')
          end
        end
      end
    end
  end

  context 'no records' do
    let(:pagination) { Paginator.new(count: 0, current_page: 1, per_page: 10) }

    include_examples 'general page item specs'
    include_examples 'general paginate specs'

    describe '#paginate' do
      it 'has the correct number of list item tags' do
        expect(paginate(pagination)).to have_selector('li', count: 3)
      end
    end
  end

  context '1 page' do
    let(:pagination) { Paginator.new(count: 5, current_page: 1, per_page: 10) }

    include_examples 'general page item specs'
    include_examples 'general paginate specs'

    describe '#paginate' do
      it 'has the correct number of list item tags' do
        expect(paginate(pagination)).to have_selector('li', count: 3)
      end
    end
  end

  context '10 pages' do
    context 'page 1' do
      let(:pagination) { Paginator.new(count: 100, current_page: 1, per_page: 10) }

      include_examples 'general page item specs'
      include_examples 'general paginate specs'

      describe '#paginate' do
        it 'has the correct number of list item tags' do
          expect(paginate(pagination)).to have_selector('li', count: 7)
        end
      end
    end

    context 'page 2' do
      let(:pagination) { Paginator.new(count: 100, current_page: 2, per_page: 10) }

      include_examples 'general page item specs'
      include_examples 'general paginate specs'

      describe '#paginate' do
        it 'has the correct number of list item tags' do
          expect(paginate(pagination)).to have_selector('li', count: 8)
        end
      end

      describe '#page_item' do
        it 'sets the correct aria-label' do
          expect(page_item(pagination.items.first)).to have_selector('a[aria-label="Previous Page"]')
          expect(page_item(pagination.items.second)).to have_selector('a[aria-label="Page 1"]')
          expect(page_item(pagination.items.third)).to have_selector('a[aria-label="Current Page"]')
          expect(page_item(pagination.items.fourth)).to have_selector('a[aria-label="Page 3"]')
          expect(page_item(pagination.items.fifth)).to have_selector('a[aria-label="Page 4"]')
          expect(page_item(pagination.items.second_to_last)).to have_selector('a[aria-label="Page 10"]')
          expect(page_item(pagination.items.last)).to have_selector('a[aria-label="Next Page"]')
        end

        it 'sets correct inner text' do
          expect(page_item(pagination.items.first)).to have_link('<')
          expect(page_item(pagination.items.second)).to have_link('1')
          expect(page_item(pagination.items.third)).to have_selector('a', text: '2')
          expect(page_item(pagination.items.fourth)).to have_link('3')
          expect(page_item(pagination.items.fifth)).to have_link('4')
          expect(page_item(pagination.items.second_to_last)).to have_link('10')
          expect(page_item(pagination.items.last)).to have_link('>')
        end
      end
    end
  end
end
