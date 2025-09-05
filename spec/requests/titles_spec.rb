require 'rails_helper'

RSpec.describe 'Titles', type: :request do
  describe 'GET /' do
    it 'returns http success' do
      get root_url
      expect(response).to be_successful
    end
  end
end
