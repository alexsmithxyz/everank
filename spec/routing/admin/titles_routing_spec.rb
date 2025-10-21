require 'rails_helper'

RSpec.describe Admin::TitlesController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/admin/titles/new').to route_to('admin/titles#new')
    end

    it 'routes to #edit' do
      expect(get: '/admin/titles/1/edit').to route_to('admin/titles#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/titles').to route_to('admin/titles#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/titles/1').to route_to('admin/titles#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/titles/1').to route_to('admin/titles#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/titles/1').to route_to('admin/titles#destroy', id: '1')
    end
  end
end
