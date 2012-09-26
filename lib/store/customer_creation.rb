module Store
  class CustomerCreation
    attr_reader :ar_instance

    def initialize(controller)
      @controller = controller
    end

    def create(data)
      @ar_instance = current_company.customers.new(data)
      @ar_instance.save
    end

  private

    def current_company
      @controller.current_company
    end
  end
end
