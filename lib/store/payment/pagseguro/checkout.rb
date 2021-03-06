module Store
  module Payment
    module Pagseguro
      class Checkout
        attr_reader :payment_url, :payment

        def initialize(controller, order)
          @order       = order
          @controller  = controller
          @payment_url = nil
        end

        def create_transaction
          @payment = ::PagSeguro::Payment.new(
            gateway_email,
            gateway_token,
            id: order.id,
            redirect_url: @controller.after_payment_return_url(:pagseguro))

          set_sender
          set_shipping if order.shipping_details.present?
          set_items

          @payment_url = payment.checkout_payment_url
        end

        private

        attr_accessor :order

        def set_sender
          payment.sender = PagSeguro::Sender.new(
            name:         order.customer.full_name,
            email:        order.customer.email,
            phone_ddd:    order.customer.first_phone_number[:area],
            phone_number: order.customer.first_phone_number[:phone])
        end

        def set_shipping
          shipping_type = case order.shipping_details.service_type
                          when 'pac'
                            PagSeguro::Shipping::PAC
                          when 'sedex'
                            PagSeguro::Shipping::SEDEX
                          else
                            PagSeguro::Shipping::UNIDENTIFIED
                          end

          payment.shipping = PagSeguro::Shipping.new(
            type:        shipping_type,
            cost:        order.shipping_details.price.to_s("F"),
            state:       order.shipping_address.state,
            city:        order.shipping_address.city,
            postal_code: order.shipping_address.zipcode,
            district:    order.shipping_address.neighborhood,
            street:      order.shipping_address.address_1,
            number:      order.shipping_address.number,
            complement:  order.shipping_address.address_2)
        end

        def set_items
          order.items.parent_items.each do |item|
            payment.items << PagSeguro::Item.new(
              id:          item.id,
              description: item.name,
              amount:      sprintf("%.2f", item.price),
              quantity:    item.quantity)
          end
        end

        def current_store
          @controller.current_store
        end

        def gateway_email
          current_store.payment_gateway.email
        end

        def gateway_token
          current_store.payment_gateway.token
        end
      end
    end
  end
end
