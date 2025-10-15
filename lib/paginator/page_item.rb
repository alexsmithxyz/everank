class Paginator::PageItem
  DEFAULT_LABELS = {
    prev: "<",
    next: ">"
  }.freeze

  def initialize(pagination:, page:)
    @page = page
    @pagination = pagination
  end

  def number
    @number ||=
      case @page
      when :next
        @pagination.current_page + 1
      when :prev
        @pagination.current_page - 1
      else
        @page
      end
  end

  def label
    DEFAULT_LABELS[@page] || @page
  end

  def aria_label
    @aria_label ||=
      if current?
        "Current Page"
      else
        case @page
        when :prev
          "Previous Page"
        when :next
          "Next Page"
        else
          "Page #{number}"
        end
      end
  end

  def responsive?
    @pagination.unresponsive_items.exclude?(@page)
  end

  def current?
    @pagination.current_page == number
  end

  def disabled?
    current? || (@page == :prev && @pagination.current_page == 1) ||
      (@page == :next && @pagination.current_page == @pagination.total_pages)
  end
end
