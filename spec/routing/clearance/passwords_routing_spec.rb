require 'rails_helper'

RSpec.describe 'Clearance::PasswordsController', type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/passwords/new').to route_to('clearance/passwords#new')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/password/edit').to route_to('clearance/passwords#edit', user_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/passwords').to route_to('clearance/passwords#create')
    end

    it 'routes to #update' do
      expect(patch: '/users/1/password').to route_to('clearance/passwords#update', user_id: '1')
    end
  end
end
