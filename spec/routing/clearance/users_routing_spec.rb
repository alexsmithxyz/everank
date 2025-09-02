require "rails_helper"

RSpec.describe Clearance::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/sign_up').to route_to('clearance/users#new')
    end

    it 'routes to #create' do
      expect(post: '/users').to route_to('clearance/users#create')
    end
  end
end
