App.CashierNewController = Ember.ObjectController.extend({
  actions: {
    submit: function() {
      this.get('content').set('createdAt', (new Date()));

      this.get('content').emberSync.save();
      this.transitionToRoute('cashier.index');
    },

    cancelCashCreation: function() {
      this.transitionToRoute('cashier.index');
    }
  }
});
