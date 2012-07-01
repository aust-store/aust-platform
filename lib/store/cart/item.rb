module Store
  class Cart
    class Item
      attr_reader :id, :title, :description, :price

      def initialize(product)
        @id = product.id
        @title = product.title
        @description = product.description
        @price = product.price
      end
    end
  end
end
