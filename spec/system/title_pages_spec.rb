require 'rails_helper'

RSpec.describe "TitlePages", type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  before(:all) do
    Title.destroy_all
    @titles = create_list :title, 45
  end

  shared_examples 'expect titles show renders correctly' do
    describe 'titles#show' do
      it 'renders titles/show' do
        visit "/titles/#{@titles.first.id}"

        expect(title).to eq(@titles.first.name)

        expect(page).to have_selector('article', count: 1)

        within 'article' do
          expect(page).to have_selector('section', count: 1)
          expect(page).to have_selector('header', count: 1)

          within 'header' do
            expect(page).to have_selector('h2', text: @titles.first.name, count: 1)
            expect(page).to have_time_tag(@titles.first.date_available, count: 1)
          end

          section_selector = 'section[aria-label="Description"]'

          expect(page).to have_selector(section_selector, count: 1)

          within section_selector do
            expect(page).to have_selector('p', text: @titles.first.description, count: 1)
          end

          expect(page).to have_selector('nav', count: 1)

          within 'nav' do
            expect(page).to have_link('Back to titles', href: '/', count: 1)
          end
        end
      end
    end
  end

  shared_examples 'expect titles index renders correctly' do
    describe 'titles#index' do
      before do
        visit titles_path
      end

      it 'renders titles/index' do
        ul_selector = 'section ul#titles'

        expect(title).to eq('Titles')
        expect(page).to have_selector('h2', text: 'Titles', count: 1)
        expect(page).to have_selector(ul_selector, count: 1)

        within ul_selector do
          expect(page).to have_selector('li', count: 20)

          @titles.first(20).each do |title|
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
                  expect(page).to have_link('View', href: "/titles/#{title.id}", count: 1)
                end
              end
            end
          end
        end
      end

      it 'only has 20 items max per page' do
        expect(page).to have_selector('section ul#titles li', count: 20)

        visit titles_path(page: 2)

        expect(page).to have_selector('section ul#titles li', count: 20)

        visit titles_path(page: 3)

        expect(page).to have_selector('section ul#titles li', count: 5)
      end
    end
  end

  shared_examples 'expect admin links to be missing on titles index' do
    describe 'titles#index' do
      before do
        visit titles_path
      end

      it 'contains no new title link' do
        expect(page).to have_no_link('New title')
      end

      it 'contains no edit title links' do
        expect(page).to have_no_link('Edit')
        expect(page).to have_no_content('View | Edit')
      end

      it 'contains no links with the admin namespace' do
        expect(page).to have_no_selector('a[href^="/admin"]')
      end
    end
  end

  shared_examples 'expect admin links to be missing on titles show' do
    describe 'titles#index' do
      before do
        visit title_path(@titles.first)
      end

      it 'contains no edit title links' do
        expect(page).to have_no_link('Edit')
        expect(page).to have_no_content('Back to titles | Edit')
      end

      it 'contains no links with the admin namespace' do
        expect(page).to have_no_selector('a[href^="/admin"]')
      end
    end
  end

  shared_examples 'view titles journey' do
    describe 'view titles journey' do
      it 'allows the user to view titles and go back' do
        visit '/'

        @titles.first(20).each do |title|
          expect(page).to have_content(title.name)
        end

        click_on 'View',
                 right_of: find(:xpath, "//h3[text()='#{@titles.first.name}']"),
                 above: find(:xpath, "//h3[text()='#{@titles.second.name}']")

        expect(current_path).to eq("/titles/#{@titles.first.id}")

        expect(page).to have_content(@titles.first.name)
        expect(page).to have_content(@titles.first.description)
        expect(page).to have_no_content(@titles.second.name)

        click_on 'Back to titles'

        @titles.first(20).each do |title|
          expect(page).to have_content(title.name)
        end

        click_on 'View',
                 below: find(:xpath, "//h3[text()='#{@titles.first.name}']"),
                 right_of: find(:xpath, "//h3[text()='#{@titles.second.name}']"),
                 above: find(:xpath, "//h3[text()='#{@titles.third.name}']")

        expect(current_path).to eq("/titles/#{@titles.second.id}")

        expect(page).to have_content(@titles.second.name)
        expect(page).to have_content(@titles.second.description)
        expect(page).to have_no_content(@titles.first.name)

        click_on 'Back to titles'
      end

      it 'allows the user to browse pages' do
        visit '/'

        click_on '>'

        expect(current_url).to include('/?page=2')

        click_on '3'

        expect(current_url).to include('/?page=3')

        click_on '1'

        expect(current_url).to include('/?page=1')
      end
    end
  end

  context 'signed out' do
    before do
      visit root_path
    end

    it 'has signed in the user' do
      expect(page).to have_no_content('Signed in as:')
    end

    include_examples 'expect titles index renders correctly'
    include_examples 'expect titles show renders correctly'
    include_examples 'expect admin links to be missing on titles index'
    include_examples 'expect admin links to be missing on titles show'
    include_examples 'view titles journey'
  end

  context 'signed in as ordinary user' do
    let(:signed_in_user) { create(:user, role: :ordinary_user) }

    before do
      visit root_path(as: signed_in_user)
    end

    it 'has signed in the user' do
      expect(page).to have_content("Signed in as: #{signed_in_user.email}")
    end

    include_examples 'expect titles index renders correctly'
    include_examples 'expect titles show renders correctly'
    include_examples 'expect admin links to be missing on titles index'
    include_examples 'expect admin links to be missing on titles show'
    include_examples 'view titles journey'
  end

  context 'signed in as admin' do
    let(:signed_in_user) { create(:user, role: :admin) }

    before do
      visit root_path(as: signed_in_user)
    end

    include_examples 'expect titles index renders correctly'
    include_examples 'expect titles show renders correctly'
    include_examples 'view titles journey'

    describe 'titles#index' do
      it 'contains new title link' do
        expect(page).to have_link('New title', href: new_admin_title_path)
      end

      it 'has edit links for titles' do
        @titles.first(20).each do |title|
          view_link = find_link('View', href: title_path(title))
          expect(page).to have_link('Edit', href: edit_admin_title_path(title), right_of: view_link)
        end
      end
    end

    describe 'titles#show' do
      before do
        visit title_path(@titles.first)
      end

      it 'contains edit title link' do
        back_link = find_link('Back to titles', href: titles_path)

        expect(page).to have_link('Edit', href: edit_admin_title_path(@titles.first), right_of: back_link)
        expect(page).to have_content('Back to titles | Edit')
      end
    end
  end
end
