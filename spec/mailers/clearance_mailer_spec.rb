require "rails_helper"

RSpec.describe ClearanceMailer, type: :mailer do
  describe 'change_password' do
    let(:user) { create(:user).tap(&:forgot_password!) }
    let(:mail) { ClearanceMailer.change_password(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Change your password')
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ 'reply@example.com' ])
    end

    it 'renders the body' do
      fixture_files = %i[text html].index_with do |ext|
        File.read(Rails.root.join("spec/fixtures/clearance/change_password.#{ext}"))
      end

      expect(mail.text_part.body.decoded).to match(fixture_files[:text])
      expect(mail.html_part.body.decoded).to match(fixture_files[:html])
    end

    it 'renders correct links in the body' do
      change_pass_url = edit_user_password_url(user, token: user.confirmation_token)

      expect(mail.text_part.body.decoded).to include(change_pass_url)
      expect(mail.html_part.body.decoded).to have_link('Change my password', href: change_pass_url)
    end
  end
end
