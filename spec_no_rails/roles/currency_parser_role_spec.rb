require "./app/roles/currency_parser_role"

describe CurrencyParser do
  describe ".to_float!" do
    before do
      @params = "R$ 4,00"
      @params.extend CurrencyParser
    end

    it "should return a valid date for ActiveRecord" do
      @params.to_float!.should == "4.0"
    end
  end
end
