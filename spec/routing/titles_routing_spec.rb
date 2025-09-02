require 'rails_helper'

RSpec.describe 'TitlesController', type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: "/").to route_to("titles#index")
    end
  end
end
