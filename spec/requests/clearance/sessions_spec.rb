require 'rails_helper'

RSpec.describe 'Clearance::Sessions', type: :request do
  context 'when signed in' do
    include_context 'signed in user'

    describe 'POST /session' do
      let(:new_user) { create :user, password: 'password' }

      before do
        sign_in_request new_user.email, 'password'
      end

      it 'sets cookie of new user' do
        expect_response_sets_remember_token_cookie new_user.remember_token
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'DELETE /sign_out' do
      before do
        delete sign_out_url(as: create(:user))
      end

      it 'clears cookie' do
        expect(response.headers['set-cookie']).to match(/remember_token=;/)
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'GET /sign_in' do
      it 'redirects to root' do
        get sign_in_url
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context 'when signed out' do
    describe 'POST /session' do
      before do
        sign_in_request user.email, pass
      end

      context 'with correct credentials' do
        let(:pass) { 'passw0rd' }
        let(:user) { create(:user, password: pass) }

        it 'sets cookie' do
          expect_response_sets_remember_token_cookie user.remember_token
        end

        it 'redirects to root' do
          expect(response).to redirect_to(root_url)
        end
      end

      context 'with incorrect credentials' do
        let(:pass) { 'wrongpass' }
        let(:user) { create(:user) }

        it "doesn't set cookie" do
          expect(response.headers['set-cookie']).not_to include(/remember_token/)
        end

        it 'is unauthorized' do
          expect(response).to be_unauthorized
        end

        it 'displays flash message' do
          expect(flash[:alert]).to eq('Bad email or password.')
        end
      end
    end

    describe 'GET /sign_in' do
      it 'redirects to root' do
        get sign_in_url
        expect(response).to be_successful
      end
    end

    describe 'DELETE /sign_out' do
      it 'redirects to sign in' do
        delete sign_out_url
        expect(response).to redirect_to(sign_in_url)
      end
    end
  end
end
