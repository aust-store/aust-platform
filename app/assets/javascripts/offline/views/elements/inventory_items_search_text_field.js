App.InventoryItemsSearchTextField = Ember.TextField.extend({
  didInsertElement: function() {
    Ember.run.later(function() {
      $('#inventory_item_search').focus();
    }, 50);
  }
});
