module Admin
  module Inventory
    class EntriesController < Admin::ApplicationController
      before_filter :sanitize_params, only: [:create, :update]

      def index
        # TODO load_good has no tests (e.g mock Good.where)

        load_good
        @entries = Admin::InventoryEntryDecorator.decorate(@good.balances)
      end

      def new
        load_good
        @entry = @good.balances.build
      end

      def create
        load_good
        @entry = @good.balances.build params[:inventory_entry]
        @entry.balance_type = "in"
        if @entry.save
          redirect_to admin_inventory_good_entries_url(@entry.good)
        else
          render "new"
        end
      end

    private

      def load_good
        @good = current_company.items.find(params[:good_id])
        raise "This doesn't belong to you" if @good.nil?
      end

      def sanitize_params
        good_params = params[:inventory_entry]
        params[:inventory_entry][:cost_per_unit] = ::Store::Currency.to_float good_params[:cost_per_unit]
      end
    end
  end
end
