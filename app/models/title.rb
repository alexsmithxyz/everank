class Title < ApplicationRecord
  include Pagination

  validates :name, presence: true
end
