App.Cart = DS.Model.extend({
  total: DS.attr('string'),
  paymentType: DS.attr('string'),
  cartItems: DS.hasMany('cartItem'),
  customer: DS.belongsTo('customer'),

  subtotal: function() {
    return this.get('cartItems').getEach('price').reduce(function(accum, item) {
      return accum + item;
    }, 0);
  }.property('cartItems.@each.price'),


  isValid: function() {
    var _this = this,
        hasItems;

    Em.run(function() {
      hasItems = _this.get('cartItems.length') > 0;
    });

    return hasItems;
  }
});
