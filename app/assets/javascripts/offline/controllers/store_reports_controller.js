App.StoreReportsController = Ember.ObjectController.extend({
  todayRevenue: function() {
    if (!this.get('content')) {
      return false;
    }

    var model = this.get('content').findBy('id', 'today_offline');
    if (model) {
      return model.get("revenue");
    }
  }.property('content.@each.revenue')
});
