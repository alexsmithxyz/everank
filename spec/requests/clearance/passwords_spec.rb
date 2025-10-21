require 'rails_helper'

RSpec.describe "Clearance::Passwords", type: :request do
  let(:user) { create(:user) }

  context 'when signed out' do
    describe 'GET /passwords/new' do
      it 'renders a successful response' do
        get new_password_url
        expect(response).to be_successful
      end
    end

    describe 'POST /passwords' do
      context 'with valid parameters' do
        it 'sends a password reset email' do
          expect do
            post passwords_url, params: { password: { email: user.email } }
          end.to change(ActionMailer::Base.deliveries, :count).by(1)
        end

        it 'is successful' do
          post passwords_url, params: { password: { email: user.email } }
          expect(response).to be_successful
        end

        it "changes user's confirmation_token" do
          expect do
            post passwords_url, params: { password: { email: user.email } }
          end.to change { user.reload.confirmation_token }
        end
      end

      context 'with invalid parameters (email not found)' do
        it 'does not send a password reset email' do
          expect do
            post passwords_url, params: { password: { email: 'nonexistent@example.com' } }
          end.to change(ActionMailer::Base.deliveries, :count).by(0)
        end

        it 'is successful' do
          post passwords_url, params: { password: { email: 'nonexistent@example.com' } }
          expect(response).to be_successful
        end
      end
    end

    describe 'GET /users/:user_id/password/edit' do
      context 'with a valid token' do
        before do
          user.forgot_password!
        end

        it 'renders a successful response' do
          get edit_user_password_url(user, token: user.confirmation_token)
          expect(response).to redirect_to(edit_user_password_url(user))
        end
      end

      context 'with an invalid token' do
        it 'is unprocessable' do
          get edit_user_password_url('invalid_token')
          expect(response).to be_unprocessable
        end

        it 'shows an error message' do
          get edit_user_password_url('invalid_token')
          expect(flash[:alert]).to eq('Please double check the URL or try submitting the form again.')
        end
      end
    end

    describe 'PUT /users/:user_id/password' do
      let(:new_password) { 'newpassword' }

      context 'with valid token and matching passwords' do
        before do
          user.forgot_password!
        end

        it 'updates the user password' do
          expect do
            patch user_password_url(user, token: user.confirmation_token),
                  params: { password_reset: { password: new_password } }
          end.to(change { user.reload.encrypted_password })
        end

        it 'signs in the user' do
          patch user_password_url(user, token: user.confirmation_token),
                params: { password_reset: { password: new_password } }
          expect_response_sets_remember_token_cookie user.reload.remember_token
        end

        it 'redirects to root path' do
          patch user_password_url(user, token: user.confirmation_token),
                params: { password_reset: { password: new_password } }
          expect(response).to redirect_to(root_url)
        end
      end


      context 'with an invalid token' do
        it 'is unprocessable' do
          get edit_user_password_url('invalid_token')
          expect(response).to be_unprocessable
        end

        it 'shows an error message' do
          get edit_user_password_url('invalid_token')
          expect(flash[:alert]).to eq('Please double check the URL or try submitting the form again.')
        end
      end
    end
  end

  context 'when signed in' do
    include_context 'ordinary user signed in'

    describe 'GET /passwords/new' do
      it 'redirects to root' do
        get new_password_path
        expect(response).to be_successful
      end
    end
  end
end
