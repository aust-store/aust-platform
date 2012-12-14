module Store
  class CompanyStatistics
    def initialize(company)
      @company = company
    end

    def statistics
      { total_items: @company.items.count }
    end
  end
end
