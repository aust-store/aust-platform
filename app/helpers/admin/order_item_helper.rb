module Admin::OrderItemHelper
  def statuses_collection
    statuses = OrderItem::VALID_STATUSES.map do |status|
      [I18n.t("activerecord.values.order_item.status.#{status}"), status.to_s]
    end
    statuses
  end
end
