module Store
  module Policy
    class CommerceSetup
      def initialize(company)
        @company = company
      end

      def pending_setup?
        missing_taxonomy?   ||
          missing_products? ||
          missing_zipcode?  ||
          missing_domain?   ||
          missing_payments? ||
          missing_analytics?
      end

      def missing_factors
        # { method_name: url }
        { missing_zipcode:  :admin_settings_path,
          missing_taxonomy: :admin_taxonomies_path,
          missing_products: :admin_inventory_items_path,
          missing_domain:   :admin_settings_path,
          missing_payments: :admin_settings_payment_methods_path,
          missing_analytics: :admin_settings_path
        }.delete_if do |x|
          !self.send("#{x}?")
        end
      end

      def missing_taxonomy?
        company.taxonomies.count < 1
      end

      def missing_products?
        company.items_on_sale_for_website_main_page.count < 1
      end

      def missing_zipcode?
        !company.has_zipcode?
      end

      def missing_domain?
        !company.has_domain?
      end

      def missing_payments?
        !company.has_payment_gateway_configured?
      end

      def missing_analytics?
        !View::GoogleAnalytics.new(company).enabled?
      end

      private

      attr_reader :company
    end
  end
end
