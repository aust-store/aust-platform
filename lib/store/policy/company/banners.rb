module Store
  module Policy
    module Company
      class Banners
        def initialize(company)
          @company = company
          Rails.logger.info @company.inspect
          Rails.logger.info @company.banners.inspect
          @banners = company.banners
        end

        def eligible?(position = nil)
          if position.blank?
            max_banners.any? do |position, total_slots|
              slots_available?(position, total_slots)
            end
          else
            position = position.to_s
            slots_available?(position, max_banners[position.to_sym])
          end
        end

        private

        def max_banners
          { main_page_central_rotative: 4,
            all_pages_right: 2 }
        end

        def slots_available?(position, total_slots)
          @banners.select { |b| b.position == position.to_s }.count < total_slots
        end
      end
    end
  end
end
