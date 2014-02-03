module Helpers
  module ApiEndpointsHelpers
    def json_datetime(datetime)
      datetime.to_json.gsub(/"/, '')
    end

    def date_match(date, year, month, day, hour, minute, second)
      date.year.should  be(year),   "year is wrong.\n\nExpected: #{year}\n     Got: #{date.year}"
      date.month.should be(month),  "month is wrong.\n\nExpected: #{month}\n     Got: #{date.month}"
      date.day.should   be(day),    "day is wrong.\n\nExpected: #{day}\n     Got: #{date.day}"
      date.hour.should  be(hour),   "hour is wrong.\n\nExpected: #{hour}\n     Got: #{date.hour}"
      date.min.should   be(minute), "minute is wrong.\n\nExpected: #{minute}\n     Got: #{date.min}"
      date.sec.should   be(second), "second is wrong.\n\nExpected: #{second}\n     Got: #{date.sec}"
      json_datetime(date)
    end
  end
end
