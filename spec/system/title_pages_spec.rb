require 'rails_helper'

RSpec.describe "TitlePages", type: :system do
  before do
    @titles = [
      create(:title, name: 'First Title', description: 'First title description', date_available: '2025-06-06'),
      create(:title, name: 'Second Title', description: 'Second title description', date_available: '2025-07-15')
    ]
  end

  describe 'GET /title/:id' do
    before do
      driven_by :rack_test
    end

    it 'renders titles/show' do
      title = @titles.first

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

  describe 'GET /' do
    before do
      driven_by :selenium, using: :headless_firefox
    end

    it 'renders titles/index' do
      visit '/'

      ul_selector = 'section ul#titles'

      expect(title).to eq('Titles')
      expect(page).to have_selector('h2', text: 'Titles', count: 1)
      expect(page).to have_selector(ul_selector, count: 1)

      within ul_selector do
        expect(page).to have_selector('li', count: @titles.count)

        @titles.each do |title|
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

    it 'only has 20 items max per page' do
      43.times do
        create :title
      end

      visit '/'

      expect(page).to have_selector('section ul#titles li', count: 20)

      visit '/?page=2'

      expect(page).to have_selector('section ul#titles li', count: 20)

      visit '/?page=3'

      expect(page).to have_selector('section ul#titles li', count: 5)
    end
  end

  describe 'view titles journey' do
    before do
      driven_by :selenium, using: :headless_firefox
    end

    it 'allows the user to view titles and go back' do
      visit '/'

      @titles.each do |title|
        expect(page).to have_content(title.name)
      end

      click_on 'View this title',
               right_of: find('h3', text: @titles.first.name),
               above: find('h3', text: @titles.second.name)

      expect(current_path).to eq("/titles/#{@titles.first.id}")

      expect(page).to have_content(@titles.first.name)
      expect(page).to have_content(@titles.first.description)
      expect(page).to have_no_content(@titles.second.name)
      expect(page).to have_no_content(@titles.second.description)

      click_on 'Back to titles'

      @titles.each do |title|
        expect(page).to have_content(title.name)
      end

      click_on 'View this title',
               below: find('h3', text: @titles.first.name),
               right_of: find('h3', text: @titles.second.name)

      expect(current_path).to eq("/titles/#{@titles.second.id}")

      expect(page).to have_content(@titles.second.name)
      expect(page).to have_content(@titles.second.description)
      expect(page).to have_no_content(@titles.first.name)
      expect(page).to have_no_content(@titles.first.description)

      click_on 'Back to titles'
    end

    it 'allows the user to browse pages' do
      43.times { create :title }

      visit '/'

      click_on '>'

      expect(current_url).to include('/?page=2')

      click_on '3'

      expect(current_url).to include('/?page=3')

      click_on '1'

      expect(current_url).to include('/?page=1')
    end
  end

  private

  def have_time_tag(datetime, count: nil)
    have_selector('time', text: datetime.strftime('%B %d, %Y'), count: count) do |time|
      time.matches_css?("[datetime=\"#{datetime}\"]")
    end
  end
end
