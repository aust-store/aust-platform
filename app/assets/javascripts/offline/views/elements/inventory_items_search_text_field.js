App.InventoryItemsSearchTextField = Ember.TextField.extend(
  App.SelectableListViewMixin, {

  didInsertElement: function() {
    Ember.run.later(function() {
      $('#inventory_item_search').focus();
    }, 20);
  },

  keyDown: function(e) {
    this._super(e);
    return true;
  }
});
