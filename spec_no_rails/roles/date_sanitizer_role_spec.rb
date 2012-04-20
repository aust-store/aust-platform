require "date"
require "./app/roles/date_sanitizer"

describe DateSanitizer do
  describe ".parse_date_for_active_record" do
    before do
      @params = "21/04/1987"
      @params.extend DateSanitizer
    end

    it "should return a valid date for ActiveRecord" do
      expected = "1987/04/21"
      @params.parse_date_for_active_record!.should == expected
    end
  end
end
