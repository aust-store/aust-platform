module DateSanitizer
  require "date"

  def parse_date_for_active_record!
    unless self.empty?
      replace Date.strptime(self, "%d/%m/%Y").strftime("%Y/%m/%d")
    end
  end
end
