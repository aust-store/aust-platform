App.CartsCustomerNewController = Ember.ObjectController.extend({
  needs: ['application', 'cartsNew', 'cartsCustomer'],

  init: function() {
    this._super();
    this.resetRecord();
  },

  resetRecord: function() {
    this.set("content", this.store.createRecord('customer'));
  },

  actions: {
    submit: function() {
      var _this   = this,
          customer = this.get('content');

      Ember.run(function() {
        customer.save().then(function(customer) {
          Ember.$('.new_customer_form').hide();
          Ember.$('.choose_customer').show();
          _this.send('setCartCustomer', customer);
          _this.resetRecord();
        }, function(response) { });
      });
    },

    cancelCustomerCreation: function() {
      Ember.run(function() {
        Ember.$(".new_customer_form").hide();
        Ember.$(".new_customer_form input[type='text']").val("");

        Ember.$(".choose_customer").show();
        Ember.$("#customer_search").focus();
      });
    }
  }
});
