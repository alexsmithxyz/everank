module ApplicationHelper
  def error_explanation(record)
    record_name = record.class.name.underscore.humanize.downcase

    tag.div id: "error-explanation" do
      concat tag.h3("#{pluralize(record.errors.count, 'error')} prohibited this #{record_name} from being saved:")

      concat(tag.ul do
        record.errors.each do |error|
          concat tag.li(error.full_message)
        end
      end)
    end
  end
end
