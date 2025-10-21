require 'clearance/rspec'

RSpec.shared_context 'ordinary user signed in' do
  pass = 'password'
  let(:user) { create(:user, password: pass, role: :ordinary_user) }

  before do
    sign_in_request user.email, pass
  end
end

RSpec.shared_context 'admin user signed in' do
  pass = 'password'
  let(:user) { create(:user, password: pass, role: :admin) }

  before do
    sign_in_request user.email, pass
  end
end
