module Admin
  module Inventory
    module Items
      class SearchController < Admin::ApplicationController
        layout false

        # TODO URGGHH, fix this smell
        attr_reader :path

        def for_adding_entry
          search_items
          # TODO what?
          @path = Proc.new { |resource| new_admin_inventory_item_entry_path(resource) }
          render_results
        end

        def index
          search_items
          # TODO what?
          @path = Proc.new { |resource| admin_inventory_item_path(resource) }
          render_results
        end

        private

        def render_results
          render "default_results"
        end

        # TODO private methods could be extracted into another class
        # TODO it's not the controller responsibility to tell how many pages
        # should be shown
        def search_items
          @resources = current_company.items.search_for(params[:name]).limit(10)
          @resources = Admin::InventoryItemDecorator.decorate(@resources)
        end
      end
    end
  end
end
