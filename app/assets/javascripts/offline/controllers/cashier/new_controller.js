App.CashierNewController = Ember.ObjectController.extend({
  actions: {
    submit: function() {
      var _this = this;

      this.get('content').set('createdAt', (new Date()));
      this.get('content').set('entryType', this.get('content.entryType.id'));

      this.get('content').emberSync.save().then(function(cashEntry) {
        _this.transitionToRoute('cashier.index');
      });
    },

    cancelCashCreation: function() {
      this.transitionToRoute('cashier.index');
    }
  }
});
