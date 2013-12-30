App.CartsCustomerView = Ember.View.extend({
  templateName: 'offline/templates/carts/customer',

  actions: {
    showCustomerForm: function() {
      Ember.run(function() {
        var searchVal = Ember.$("#customer_search").val();

        Ember.$(".new_customer_form").show();
        Ember.$(".choose_customer").hide();
        Ember.$("#new_customer_name").val(searchVal);
        Ember.$("#new_customer_name").focus();
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
