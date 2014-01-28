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
        Ember.$("section.cart_customer input:visible").filter(":first").focus();
      });
      return false;
    }
    this._super(e);
    return true;
  },

  focusOut: function(event) {
    var _this = this;
    Em.run.later(function() {
      if (_this.get('controller')) {
        _this.get('controller').send("resetSearchResults");
      }
    }, 30);
  },
});
