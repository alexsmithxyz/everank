require 'rails_helper'

RSpec.describe "TitlePages", type: :system do
  describe 'GET /title/:id' do
    before do
      driven_by :rack_test
    end

    it 'renders titles/show' do
      title = create :title, date_available: '2025-06-06'

      visit "/titles/#{title.id}"

      expect(page).to have_selector('article', count: 1)

      within 'article' do
        expect(page).to have_selector('section', count: 1)
        expect(page).to have_selector('header', count: 1)

        within 'header' do
          expect(page).to have_selector('h2', text: title.name, count: 1)
          expect(page).to have_time_tag(title.date_available, count: 1)
        end

        section_selector = 'section[aria-label="Description"]'

        expect(page).to have_selector(section_selector, count: 1)

        within section_selector do
          expect(page).to have_selector('p', text: title.description, count: 1)
        end

        expect(page).to have_selector('nav', count: 1)

        within 'nav' do
          expect(page).to have_link('Back to titles', href: '/', count: 1)
        end
      end
    end
  end

  describe 'GET /titles' do
    before do
      driven_by :selenium, using: :headless_firefox
    end

    it 'renders titles/index' do
      titles = [
        create(:title, name: 'First Title', date_available: '2025-06-06'),
        create(:title, name: 'Second Title', date_available: '2025-07-15')
      ]

      visit '/'

      ul_selector = 'section ul#titles'

      expect(title).to eq('Titles')
      expect(page).to have_selector('h2', text: 'Titles', count: 1)
      expect(page).to have_selector(ul_selector, count: 1)

      within ul_selector do
        expect(page).to have_selector('li', count: titles.count)

        titles.each do |title|
          li_selector = "li#title_#{title.id}"
          expect(page).to have_selector(li_selector, count: 1)

          within li_selector do
            expect(page).to have_selector('article', count: 1)

            within 'article' do
              expect(page).to have_selector('header', left_of: find('nav'), count: 1)

              within 'header' do
                expect(page).to have_selector('h3', text: title.name, count: 1)
                expect(page).to have_time_tag(title.date_available, count: 1)
              end

              expect(page).to have_selector('nav', right_of: find('header'), count: 1)

              within 'nav' do
                expect(page).to have_link('View this title', href: "/titles/#{title.id}", count: 1)
              end
            end
          end
        end
      end
    end
  end

  private

  def have_time_tag(datetime, count: nil)
    have_selector('time', text: datetime.strftime('%B %d, %Y'), count: count) do |time|
      time.matches_css?("[datetime=\"#{datetime}\"]")
    end
  end
end
