module Pagination
  extend ActiveSupport::Concern

  class_methods do
    def paginate(per_page:, current_page:)
      per_page = per_page.to_i
      current_page = current_page.to_i

      [
        Paginator.new(count: count, current_page: current_page, per_page: per_page),
        limit(per_page).offset(per_page * (current_page - 1))
      ]
    end
  end
end
