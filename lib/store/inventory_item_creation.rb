module Store
  class InventoryItemCreation
    def initialize(controller)
      @controller = controller
      @item = nil
    end

    def create(params)
      @item = current_company.items
        .new(params.merge(user: current_user))
      @item.save
    end

    def active_record_item
      @item
    end

  private

    def current_company
      @controller.current_company
    end

    def current_user
      @controller.current_user
    end
  end
end