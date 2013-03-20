App.OrdersStatisticsController = Ember.ObjectController.extend({
  revenue: function() {
    return this.content.get('firstObject.revenue');
  }.property('firstObject.revenue')
});
