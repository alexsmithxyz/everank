require 'rails_helper'

RSpec.describe 'Clearance::SessionsController', type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: "/sign_in").to route_to("clearance/sessions#new")
    end

    it 'routes to #create' do
      expect(post: "/session").to route_to("clearance/sessions#create")
    end

    it 'routes to #destroy' do
      expect(delete: "/sign_out").to route_to("clearance/sessions#destroy")
    end
  end
end
