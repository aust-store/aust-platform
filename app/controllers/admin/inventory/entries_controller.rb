module Admin
  module Inventory
    class EntriesController < Admin::ApplicationController
      before_filter :sanitize_params, only: [:create, :update]
      before_filter :load_entries_summary, only: [:new, :edit, :create]

      def index
        # TODO load_good has no tests (e.g mock Good.where)

        load_good
        @entries = Admin::InventoryEntryDecorator.decorate(@good.balances)
      end

      def new
        load_good
        entry = @good.balances.build
        @entry = Admin::InventoryEntryDecorator.decorate(entry)
      end

      def create
        load_good
        @entry = @good.balances.build params[:inventory_entry]
        @entry.store_id = current_company.id
        @entry.balance_type = "in"
        if @entry.save
          redirect_to admin_inventory_good_entries_url(@entry.good)
        else
          @entry = Admin::InventoryEntryDecorator.decorate(@entry)
          render "new"
        end
      end

    private

      def load_good
        @good ||= current_company.items.find(params[:good_id])
        raise "This doesn't belong to you" if @good.nil?
        @good
      end

      def load_entries_summary
        last_entries = load_good.balances.order("id desc").last(6)
        @last_entries = Admin::InventoryEntryDecorator.decorate(last_entries)
      end

      def sanitize_params
        good_params = params[:inventory_entry]
        cost_per_unit = ::Store::Currency.to_float good_params[:cost_per_unit]

        if cost_per_unit == 0.0
          params[:inventory_entry][:cost_per_unit] = ""
        else
          params[:inventory_entry][:cost_per_unit] = cost_per_unit
        end
      end
    end
  end
end
