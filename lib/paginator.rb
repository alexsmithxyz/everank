class Paginator
  attr_reader :count, :current_page, :per_page, :total_pages, :items, :unresponsive_items

  def initialize(count:, current_page:, per_page:)
    @count = count
    @current_page = current_page
    @per_page = per_page
    @total_pages = (@count.to_f / @per_page).ceil
    @total_pages = 1 if @total_pages < 1

    @unresponsive_items = [:prev, 1]
    @unresponsive_items += ((@current_page - 1)..(@current_page + 1)).to_a
    @unresponsive_items += [@total_pages, :next]

    @items = item_series.map do |page|
      PageItem.new(pagination: self, page: page)
    end
  end

  private

  def item_series
    series = [:prev, 1]
    series += ([2, @current_page - 3].max..[@current_page + 3, @total_pages - 1].min).to_a
    series += [@total_pages, :next]

    series.uniq
  end
end
