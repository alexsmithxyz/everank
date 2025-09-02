require 'rails_helper'

RSpec.describe 'layouts/application', type: :view do
  describe 'flash messages' do
    context 'when flash messages present' do
      let(:flash_messages) do
        {
          notice: 'Example notice flash message.',
          alert: 'Example alert flash message.'
        }
      end

      before do
        allow(view).to receive(:flash).and_return(flash_messages)
        render
      end

      it 'renders notice flash message' do
        expect(rendered).to have_selector('div#flash') do |div|
          expect(div).to have_selector('div.flash.notice', text: flash_messages[:notice])
        end
      end

      it 'renders alert flash message' do
        expect(rendered).to have_selector('div#flash') do |div|
          expect(div).to have_selector('div.flash.alert', text: flash_messages[:alert])
        end
      end
    end

    context 'when flash messages not present' do
      before do
        allow(view).to receive(:flash).and_return({})
        render
      end

      it "doesn't render flash messages" do
        expect(rendered).to have_selector('div#flash') do |div|
          expect(div).to have_no_selector('div.flash')
        end
      end
    end
  end

  describe 'signed in/out content' do
    context 'when signed out' do
      it "doesn't render signed in content" do
        render
        expect(rendered).to have_no_content('Signed in as:')
      end

      it "doesn't render sign out button" do
        render
        expect(rendered).to have_no_selector("form[action=\"#{sign_out_path}\"]")
      end

      %w[users sessions].each do |controller_name|
        context "#{controller_name} controller" do
          before do
            allow(view).to receive(:controller_name).and_return(controller_name)
            render
          end

          it "doesn't render sign in link" do
            expect_no_sign_in_link
          end

          it "doesn't render sign up link" do
            expect_no_sign_up_link
          end
        end
      end

      context 'not sessions or users controller' do
        before do
          allow(view).to receive(:controller_name).and_return('titles')
          render
        end

        it 'renders sign in link' do
          expect(rendered).to have_link('Sign in', href: sign_in_path)
        end

        it 'renders sign up link' do
          expect(rendered).to have_link('Sign up', href: sign_up_path)
        end
      end
    end

    context 'when signed in' do
      before do
        sign_in_as create(:user, email: 'test@example.com')
      end

      it 'renders signed in content' do
        render
        expect(rendered).to have_content('Signed in as: test@example.com')
      end

      it 'renders sign out button' do
        render

        sign_out_selector = "form[action=\"#{sign_out_path}\"]"

        expect(rendered).to have_selector(sign_out_selector) do |form|
          expect(form).to have_selector('input[name="_method"][value="delete"]', visible: false)
          expect(form).to have_button('Sign out')
        end
      end

      context 'not sessions or users controller' do
        before do
          allow(view).to receive(:controller_name).and_return('titles')
          render
        end

        it "doesn't render sign in link" do
          expect_no_sign_in_link
        end

        it "doesn't render sign up link" do
          expect_no_sign_up_link
        end
      end
    end
  end

  private

  def expect_no_sign_in_link
    expect(rendered).to have_no_link('Sign in')
  end

  def expect_no_sign_up_link
    expect(rendered).to have_no_link('Sign up')
  end
end
