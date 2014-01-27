App.InventoryItemsSearchTextField = Ember.TextField.extend({
  didInsertElement: function() {
    Ember.run.later(function() {
      $('#inventory_item_search').focus();
    }, 20);
  },

  keyDown: function(e) {
    var offset;

    // up arrow
    // down arrow
    if (e.keyCode === 38) { offset = -1; }
    else if (e.keyCode === 40) { offset = 1; }

    if (offset) {
      e.stopPropagation();
      this.get('controller').send('changeSelection', { direction: offset });
      return false;
    }

    return true;
  }
});
