App.CartsCustomerController = Ember.ArrayController.extend({
  needs: ['application', 'cartsNew'],
  searchQuery: null,
  currentCustomer: null,

  isCustomerDefined: function() {
    return this.cart().get('customer.firstName');
  }.property('controllers.cartsNew.content.customer.firstName'),

  userTyping: function(value) {
    var _this = this,
        searchQuery = this.get('searchQuery');

    Ember.run.later(function() {
      if (typeof searchQuery == "string" && searchQuery.length > 0) {
        searchResults = _this.store.find('customer', { search: searchQuery });

        _this.set('content', searchResults);
      } else
        _this.set('content', null)

    }, 400);
  }.observes("searchQuery"),

  submitCustomerCreation: function() {
    var firstName = $("#new_customer_name").val(),
        lastName  = $("#new_customer_lastname").val(),
        email     = $("#new_customer_email").val(),
        cpf       = $("#new_customer_cpf").val(),
        customer  = App.Customer.createRecord({
          firstName: firstName,
          lastName:  lastName,
          email:     email,
          socialSecurityNumber: cpf
        });

    $('.new_customer').hide();
    $('.choose_customer').show();
    this.setCartCustomer(customer);
  },

  autoResetSearch: function() {
    var isCustomerPresent = this.get('controllers.cartsNew.content.customer.firstName');
    if (!isCustomerPresent) {
      this.set('searchQuery', null);
      this.set('content',     null);
    }
  }.observes('controllers.cartsNew.content.customer.firstName'),

  cart: function() {
    return this.get('controllers.cartsNew').get('content');
  },

  actions: {
    onSearchCommit: function(customerName) {
      // no items found
      if (!this.get('content.firstObject') && this.get('model.isLoaded')) {
        // Replace search input with customer creation form
        Ember.run(function() {
          $('.new_customer').show();
          $('.choose_customer').hide();
          $("#new_customer_name").val(customerName)
        });
      }
    },

    setCartCustomer: function(customer) {
      this.cart().set('customer', customer);
      this.set("currentCustomer", customer);
    },

    resetSearch: function() {
      var _this = this;

      this.cart().set('customer', null);
      this.set("currentCustomer", null);

      Ember.run.later(function() {
        if (_this.isDestroyed) { return; }

        Ember.$("#customer_search").focus();
      }, 10);
    }
  }
});
