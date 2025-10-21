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

          expect(page).to have_button(form_submit_text, below: desc_field)
        end

        expect(page).to have_link('Back to titles', href: titles_path, below: form)
      end
    end
  end

  shared_examples 'display validation errors on admin titles form' do
    before do
      click_on form_submit_text
    end

    it 'displays error explanation on validation error' do
      within '#error-explanation' do
        expect(page).to have_selector('h3', text: '1 error prohibited this title from being saved:')
        expect(page).to have_selector('ul li', text: "Name can't be blank")
      end
    end

    it 'puts invalid fields in field_with_errors container' do
      expect(page).to have_selector('.field_with_errors label[for="title_name"]', text: 'Name')
      expect(page).to have_selector('.field_with_errors input[name="title[name]"][type="text"]')
    end
  end

  describe 'GET /admin/titles/new' do
    before do
      visit new_admin_title_path(as: signed_in_user)
    end

    let(:controller_action) { 'new' }
    let(:form_action) { admin_titles_path }

    include_examples 'expect it renders admin titles form'
    include_examples 'display validation errors on admin titles form'

    it "sets the page's title correctly" do
      expect(title).to eq('New title')
    end

    it 'creates a title' do
      title_attributes = {
        name: 'Test Admin Title Create',
        date_available: '2025-10-21',
        description: 'This is the description to test the admin title create form'
      }

      fill_in 'Name', with: title_attributes[:name]
      fill_in 'Date available', with: title_attributes[:date_available]
      fill_in 'Description', with: title_attributes[:description]

      expect do
        click_on 'Create Title'
      end.to change(Title, :count).by(1)

      last_title = Title.last

      expect(last_title.name).to eq(title_attributes[:name])
      expect(last_title.date_available.to_s).to eq(title_attributes[:date_available])
      expect(last_title.description).to eq(title_attributes[:description])

      expect(page).to have_selector('#flash .flash.notice', text: 'Title was successfully created.')
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

    it 'updates a title' do
      title_attributes = {
        name: 'Test Admin Title Update',
        date_available: '2025-10-21',
        description: 'This is the description to test the admin title update form'
      }

      fill_in 'Name', with: title_attributes[:name]
      fill_in 'Date available', with: title_attributes[:date_available]
      fill_in 'Description', with: title_attributes[:description]

      title_changes = lambda do
        title_record.slice(:name, :date_available, :description).tap do
          _1[:date_available] = _1[:date_available].to_s
        end
      end

      expect do
        click_on 'Update Title'
        title_record.reload
      end.to change(title_changes, :call).to(title_attributes)

      expect(page).to have_selector('#flash .flash.notice', text: 'Title was successfully updated.')
    end

    context 'missing title name' do
      before do
        fill_in 'Name', with: ''
      end

      include_examples 'display validation errors on admin titles form'
    end
  end

  describe 'DELETE /admin/titles/:id' do
    before do
      visit edit_admin_title_path(title_record, as: signed_in_user)
    end

    let(:title_record) { create(:title) }

    it 'destroys a title' do
      expect_correct_things_when_deleting_title
    end
  end

  describe 'logging out of admin and logging into user journey' do
    let(:admin) { create(:user, password: 'password', role: :admin) }
    let(:ordinary_user) { create(:user, password: 'password', role: :ordinary_user) }

    it "doesn't give admin access to ordinary user" do
      visit sign_in_path

      fill_in 'Email', with: admin.email
      fill_in 'Password', with: 'password'
      click_on 'Sign in'

      expect(page).to have_content("Signed in as: #{admin.email}")

      click_on 'New title'

      expect(page).to have_selector('h2', text: 'New title')
      expect(page).to have_button('Create Title')

      click_on 'Sign out'

      # it takes us to sign in when we sign out
      fill_in 'Email', with: ordinary_user.email
      fill_in 'Password', with: 'password'
      click_on 'Sign in'

      expect(page).to have_content("Signed in as: #{ordinary_user.email}")
      expect(page).to have_no_link('New title')

      visit new_admin_title_path

      expect(page).to have_content('The page you were looking for doesn’t exist.')

      go_back

      # just to make sure the previous `visit` didn't change the user
      expect(page).to have_content("Signed in as: #{ordinary_user.email}")
    end
  end

  describe 'title create, update and destroy journey' do
    let(:admin) { create(:user, password: 'password', role: :admin) }

    it 'creates, updates and destroys a title' do
      title_attributes = {
        name: 'Test Admin Title Create, Update and Destroy Journey',
        date_available: '2025-10-21',
        description: 'This is the description to test creating, updating and destroying a title.'
      }

      visit root_path(as: admin)

      click_on 'New title'

      fill_in 'Name', with: title_attributes[:name]
      fill_in 'Date available', with: title_attributes[:date_available]
      fill_in 'Description', with: title_attributes[:description]

      expect do
        click_on 'Create Title'
      end.to change(Title, :count).by(1)

      expect(page).to have_selector('#flash .flash.notice', text: 'Title was successfully created.')

      within 'article' do
        expect(page).to have_selector('h2', text: title_attributes[:name])
        expect(page).to have_time_tag(title_attributes[:date_available].to_date)
        expect(page).to have_content(title_attributes[:description])
      end

      title_attributes = {
        name: 'Test Continuing Admin Title Update and Destroy Journey',
        date_available: '2025-10-01',
        description: 'This is the description to test updating and destroying a title after having created it.'
      }

      click_on 'Edit'

      fill_in 'Name', with: title_attributes[:name]
      fill_in 'Date available', with: title_attributes[:date_available]
      fill_in 'Description', with: title_attributes[:description]

      click_on 'Update Title'

      expect(page).to have_selector('#flash .flash.notice', text: 'Title was successfully updated.')

      within 'article' do
        expect(page).to have_selector('h2', text: title_attributes[:name])
        expect(page).to have_time_tag(title_attributes[:date_available].to_date)
        expect(page).to have_content(title_attributes[:description])
      end

      click_on 'Edit'

      expect_correct_things_when_deleting_title
    end
  end

  private

  def expect_correct_things_when_deleting_title
    expect do
      click_on 'Delete this title'
      accept_confirm

      # we need to expect this anyway and it causes the test to wait or else
      # it checks for the change too early
      expect(page).to have_selector('#flash .flash.notice', text: 'Title was successfully destroyed.')
    end.to change(Title, :count).by(-1)
  end

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

  def form_submit_text
    case controller_action
    when 'new'
      'Create Title'
    when 'edit'
      'Update Title'
    end
  end
end
