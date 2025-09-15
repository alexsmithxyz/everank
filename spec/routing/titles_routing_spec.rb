require "rails_helper"

RSpec.describe TitlesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/').to route_to('titles#index')
    end

    it 'routes to #show' do
      expect(get: '/titles/1').to route_to('titles#show', id: '1')
    end
  end
end
