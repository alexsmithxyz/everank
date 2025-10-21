module System
  module ApplicationHelpers
    def have_time_tag(datetime, count: nil)
      have_selector('time', text: datetime.strftime('%B %d, %Y'), count: count) do |time|
        time.matches_css?("[datetime=\"#{datetime}\"]")
      end
    end
  end
end
