module Store
  module Payment
    module Pagseguro
      class Checkout
        attr_reader :payment_url

        def initialize(controller, order)
          @order       = order
          @controller  = controller
          @payment_url = nil
        end

        def create_transaction
          @payment = PagSeguro::Payment.new('chavedomundo@gmail.com',
                                           '3FD7050526694058A462366B32EDFE96',
                                           id: order.id,
                                           redirect_url: @controller.after_payment_return_url(:pagseguro))
          set_sender
          set_shipping if order.shipping_options.present?
          set_items

          @payment_url = payment.checkout_payment_url
        end

        private

        attr_accessor :order, :payment

        def set_sender
          payment.sender = PagSeguro::Sender.new(
            name:         order.user.full_name,
            email:        order.user.email,
            phone_ddd:    order.user.first_phone_number[:area],
            phone_number: order.user.first_phone_number[:phone])
        end

        def set_shipping
          shipping_type = case order.shipping_options.service_type
                          when 'pac'
                            PagSeguro::Shipping::PAC
                          when 'sedex'
                            PagSeguro::Shipping::SEDEX
                          else
                            PagSeguro::Shipping::UNIDENTIFIED
                          end

          payment.shipping = PagSeguro::Shipping.new(
            type:        shipping_type,
            state:       order.shipping_address.state,
            city:        order.shipping_address.city,
            postal_code: order.shipping_address.zipcode,
            district:    order.shipping_address.neighborhood,
            street:      order.shipping_address.address_1,
            number:      order.shipping_address.number,
            complement:  order.shipping_address.address_2)
        end

        def set_items
          order.all_items.each do |item|
            payment.items << PagSeguro::Item.new(
              id:          item.id,
              description: item.name,
              amount:      sprintf("%.2f", item.price),
              quantity:    item.quantity)
          end
        end
      end
    end
  end
end
