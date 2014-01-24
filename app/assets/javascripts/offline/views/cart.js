App.CartsIndexView = Ember.View.extend({
  templateName: 'offline/templates/carts/index'
});

App.CartsNewView = Ember.View.extend({
  templateName: 'offline/templates/carts/new',

  didInsertElement: function() {
    /**
     * Helps in development:
     *
     *   - adds item to cart
     */
    if (window.developmentHelpers) {
      Em.run.later(function() {
        Ember.$("#inventory_item_search").val("RGS").trigger('change');

        Em.run.later(function() {
          Ember.$(".listing.inventory_items a.js_inventory_item").click();
        }, 500);
      }, 20);
    }
  }
});

App.CartsCustomerView = Ember.View.extend({
  templateName: 'offline/templates/carts/customer'
});
