require 'clearance/rspec'

RSpec.shared_context 'signed in user' do
  pass = 'password'

  let(:user) { create(:user, password: pass) }

  before do
    sign_in_request user.email, pass
  end
end
