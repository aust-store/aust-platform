module Admin
  module Inventory
    class EntriesController < Admin::ApplicationController
      before_filter :sanitize_params, only: [:create, :update]
      before_filter :load_entries_summary, only: [:new, :edit, :create]

      def index
        # TODO load_item has no tests (e.g mock item.where)

        load_item
        @entries = Admin::InventoryEntryDecorator.decorate_collection(@item.balances)
      end

      def new
        load_item
        entry = @item.balances.build
        @entry = entry # Admin::InventoryEntryDecorator.decorate(entry)
      end

      def create
        load_item
        @entry = @item.balances.build params[:inventory_entry]
        @entry.store_id = current_company.id
        @entry.admin_user_id = current_user.id
        if @entry.save
          redirect_to admin_inventory_item_entries_url(@entry.inventory_item)
        else
          @entry = Admin::InventoryEntryDecorator.decorate(@entry)
          render "new"
        end
      end

      def update
        item = current_company.items.friendly.find(params[:item_id])
        entry = item.balances.find(params[:id])
        if entry.update_attributes(params[:inventory_entry])
          respond_to do |format|
            format.js { render json: item, status: 200 }
            format.html { redirect_to params[:redirect_to] if params[:redirect_to].present? }
          end
        else
          respond_to do |format|
            format.js { render json: item, status: 400 }
            format.html { redirect_to params[:redirect_to] if params[:redirect_to].present? }
          end
        end
      end

    private

      def load_item
        @item ||= current_company.items.friendly.find(params[:item_id])
        raise "This doesn't belong to you" if @item.nil?
        @item
      end

      def load_entries_summary
        last_entries = load_item.balances.order("id desc").last(6)
        @last_entries = Admin::InventoryEntryDecorator.decorate(last_entries)
      end

      def sanitize_params
        item_params = params[:inventory_entry]
        if item_params[:cost_per_unit].present?
          cost_per_unit = ::Store::Currency.to_float item_params[:cost_per_unit]

          if cost_per_unit == 0.0
            params[:inventory_entry][:cost_per_unit] = ""
          else
            params[:inventory_entry][:cost_per_unit] = cost_per_unit
          end
        end
      end
    end
  end
end
