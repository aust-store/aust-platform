module Admin
  module Settings
    module PaymentMethods
      class PagseguroWizardController < Admin::ApplicationController
        include Wicked::Wizard

        steps :email, :token, :notifications, :success

        def show
          @step = step
          @gateway = payment_gateway
          render_wizard
        end

        def update
          @gateway = payment_gateway
          @gateway.update_attributes(params[:payment_gateway])
          render_wizard @gateway
        end

        private

        def payment_gateway
          current_company.payment_gateway ||
            current_company.build_payment_gateway(name: :pagseguro)
        end
      end
    end
  end
end
