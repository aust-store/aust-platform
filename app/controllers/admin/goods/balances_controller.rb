module Admin
  module Goods
    class BalancesController < Admin::ApplicationController
      before_filter :sanitize_params, only: [:create, :update]

      def index
        # TODO load_good has no tests (e.g mock Good.where)
        load_good
        @balances = Admin::GoodBalanceDecorator.decorate(@good.balances)
      end

      def new
        load_good
        @balance = @good.balances.build
      end

      def create
        load_good
        @balance = @good.balances.build params[:good_balance]
        @balance.balance_type = "in"
        if @balance.save
          redirect_to admin_inventory_good_balances_url(@balance.good)
        else
          render "new"
        end
      end

      def update
        load_good
        @balance = @good.balances.find params[:id]
        if @balance.update_attributes params[:good_balance]
          redirect_to admin_inventory_good_balances_url(@balance.good)
        else
          render "edit"
        end
      end

      private

      def load_good
        @good = Good.where(id: params[:good_id]).within_company(current_user.company).first
        raise "This doesn't belong to you" if @good.nil?
      end

      # TODO there's no test coverage for this
      def sanitize_params
        good_params = params[:good_balance]
        params[:good_balance][:cost_per_unit] = Store::Currency.to_float good_params[:cost_per_unit]
      end
    end
  end
end
