require 'rails_helper'

RSpec.describe "Paginators", type: :system do
  before do
    driven_by :selenium, using: :headless_firefox

    60.times { create(:title) }
  end

  # can't use the `right_of` option because either border or inset or both on
  # the `a` tags cause overlap which stops it from working. instead we just
  # expect them to have the same 'top' and that 'right' is within one pixel of
  # previous 'left'
  it 'displays page items horizontally' do
    visit '/'

    within 'nav.pagination ul' do
      page_items = [
        find('a', text: '<'),
        find('a', text: '1'),
        find_link('2'),
        find_link('3'),
        find('a', text: '>')
      ]

      page_items.each.with_index do |link, i|
        next if i.zero?

        last_item = page_items[i - 1]
        last_right = last_item.rect.x + last_item.rect.width

        expect(link.rect.y).to eq(last_item.rect.y)
        expect(link.rect.x.round(2)).to be_in((last_right - 1).round(2)..last_right.round(2))
      end
    end
  end
end
