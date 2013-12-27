App.Cart = DS.Model.extend({
  total: DS.attr('string'),
  items: DS.hasMany('cartItem'),
  customer: DS.belongsTo,

  subtotal: function() {
    return this.get('items').getEach('price').reduce(function(accum, item) {
      return accum + item;
    }, 0);
  }.property('items.@each.price'),


  isValid: function() {
    var _this = this,
        hasItems, hasCustomer;

    Ember.run(function() {
      hasItems = _this.get('items.length') > 0;
      hasCustomer = _this.get('customer.id');
    });

    return hasItems && hasCustomer;
  }
});
