module Admin
  module Goods
    class SearchController < Admin::ApplicationController
      layout false

      # TODO URGGHH, fix this smell
      attr_reader :path

      def for_adding_balance
        search_goods
        # TODO what?
        @path = Proc.new { |resource| new_admin_inventory_good_balance_path(resource) }
        render_results
      end

      def index
        search_goods
        # TODO what?
        @path = Proc.new { |resource| admin_inventory_good_path(resource) }
        render_results
      end

    private

      def render_results
        render "default_results"
      end

      # TODO private methods could be extracted into another class
      # TODO it's not the controller responsibility to tell how many pages
      # should be shown
      def search_goods
       @resources = Good.search_for params[:name], current_user.company_id, page: 1, per_page: 10
      end
    end
  end
end
