module Store
  module Policy
    module Company
      class LateralBanners

        def initialize(company)
          @company = company
        end
        def elegible?
          @company.banners.count < 3
        end
      end
    end
  end

end
