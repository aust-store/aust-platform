App.CashierItemController = Ember.ObjectController.extend({
  isAddition: function() {
    return this.get('content.entryType') == 'addition';
  }.property(),

  isSubtraction: function() {
    return this.get('content.entryType') == 'subtraction';
  }.property()
});
