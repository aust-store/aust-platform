App.CashierIndexController = Ember.ArrayController.extend({
  itemController: "cashierItem",
  ordersTotal: function() {
    return this.get('todaysOrders').reduce(function(accum, item) {
      return accum + item.get('total');
    }, 0);
  }.property("todaysOrders.@each.id"),

  totalCash: function() {
    return this.get('content').reduce(function(accum, item) {
      if (item.get('entryType') == 'addition') {
        return accum + item.get('amount');
      } else if (item.get('entryType') == 'subtraction') {
        return accum - item.get('amount');
      }
    }, 0);
  }.property("content.@each.amount"),

  expectedCashBalance: function() {
    return this.get('ordersTotal') + this.get('totalCash');
  }.property("ordersTotal", "totalCash"),
});
