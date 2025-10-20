require 'rails_helper'

RSpec.describe "Admin::TitlePages", type: :system do
  before do
    driven_by :selenium, using: :headless_firefox
  end

  let(:signed_in_user) { create(:user, role: :admin) }

  shared_examples 'expect it renders admin titles form' do
    it 'renders form correctly' do
      expect(%w[new edit]).to include(controller_action)

      within 'div.form-container' do
        form = find_form

        expect(page).to have_selector('h2', text: "#{controller_action.capitalize} title", count: 1, above: form)

        within form do
          name_label = find('label[for="title_name"]', text: 'Name')
          name_field = find_field('title[name]', type: 'text', below: name_label)
          date_label = find('label[for="title_date_available"]', text: 'Date available', below: name_field)
          date_field = find_field('title[date_available]', type: 'date', below: date_label)
          desc_label = find('label[for="title_description"]', text: 'Description', below: date_field)
          desc_field = find_field('title[description]', type: 'textarea', below: desc_label)

          button_text =
            case controller_action
            when 'new'
              'Create Title'
            when 'edit'
              'Update Title'
            end

          expect(page).to have_button(button_text, below: desc_field)
        end

        expect(page).to have_link('Back to titles', href: titles_path, below: form)
      end
    end
  end

  describe 'GET /admin/titles/new' do
    before do
      visit new_admin_title_path(as: signed_in_user)
    end

    let(:controller_action) { 'new' }
    let(:form_action) { admin_titles_path }

    include_examples 'expect it renders admin titles form'

    it "sets the page's title correctly" do
      expect(title).to eq('New title')
    end
  end

  describe 'GET /admin/titles/:id/edit' do
    before do
      visit edit_admin_title_path(title_record, as: signed_in_user)
    end

    let(:title_record) { create(:title) }
    let(:controller_action) { 'edit' }
    let(:form_action) { admin_title_path(title_record) }

    include_examples 'expect it renders admin titles form'

    it "sets the page's title correctly" do
      expect(title).to eq('Editing title')
    end

    it 'has a view this title link' do
      expect(page).to have_xpath(find_view_link.path, below: find_form)
    end

    it 'has a delete button' do
      expect(page).to have_xpath(find_delete_button.path, below: find_view_link)
    end

    it 'has back to titles link' do
      expect(page).to have_link('Back to titles', href: titles_path, below: find_delete_button)
    end
  end

  private

  def find_view_link
    find_link('View this title', href: title_path(title_record))
  end

  def find_delete_button
    find(%(form[action="#{admin_title_path(title_record)}"])) do |form|
      form.has_selector?('input[type="hidden"][name="_method"][value="delete"]', visible: false) &&
        form.has_selector?('button[data-turbo-confirm="Are you sure?"]', text: 'Delete this title')
    end
  end

  def find_form
    find(%(form[action="#{form_action}"][method="post"])) do |form|
      form.has_no_selector?('input[type="hidden"][name="_method"][value="delete"]', visible: false)
    end
  end
end
