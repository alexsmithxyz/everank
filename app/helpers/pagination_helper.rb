module PaginationHelper
  def paginate(pagination)
    tag.div class: "flex justify-center mt-5" do
      tag.nav class: "pagination", 'aria-label': "Pagination" do
        tag.ul do
          pagination.items.each do |item|
            concat page_item(item)
          end
        end
      end
    end
  end

  private

  def page_item(item)
    tag.li class: class_names(responsive: item.responsive?) do
      options = { aria: { label: item.aria_label } }

      options[:aria][:current] = "page" if item.current?

      if item.disabled?
        options.deep_merge!(role: "link", aria: { disabled: true })
      else
        options[:href] = url_for(controller: controller_name, action: action_name, page: item.number)
      end

      tag.a item.label, **options
    end
  end
end
