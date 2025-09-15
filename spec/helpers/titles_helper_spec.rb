require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TitlesHelper. For example:
#
# describe TitlesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TitlesHelper, type: :helper do
  describe '#titles_path' do
    it 'returns the root path' do
      expect(titles_path).to eq(root_path)
    end

    it 'passes options to root_path' do
      options = { locale: :en }
      expect(titles_path(options)).to eq(root_path(options))
    end
  end

  describe '#titles_url' do
    it 'returns the root url' do
      expect(titles_url).to eq(root_url)
    end

    it 'passes options to root_url' do
      options = { locale: :en }
      expect(titles_url(options)).to eq(root_url(options))
    end
  end
end
