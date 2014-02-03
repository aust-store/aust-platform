App.InventoryItemsSearchTextField = Ember.TextField.extend(
  App.SelectableListViewMixin, {

  didInsertElement: function() {
    Ember.run.later(function() {
      $('#inventory_item_search').focus();
    }, 20);
  },

  keyDown: function(e) {
    // tab
    if (e.keyCode === 9) {
      this.get('controller').send("resetSearchResults");
      Em.run(function() {
        Ember.$(".cart_customer_section input:visible").filter(":first").focus();
      });
      return false;
    }
    this._super(e);
    return true;
  },
});
