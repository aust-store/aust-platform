App.Cart = DS.Model.extend({
  total: DS.attr('string'),
  paymentType: DS.attr('string'),
  cartItems: DS.hasMany('cartItem'),
  customer: DS.belongsTo('customer'),

  subtotal: function() {
    return this.private.sumPrice.call(this, "price");
  }.property('cartItems.@each.price'),

  subtotalForInstallments: function() {
    return this.private.sumPrice.call(this, "priceForInstallments");
  }.property('cartItems.@each.priceForInstallments'),

  isValid: function() {
    var _this = this,
        hasItems;

    Em.run(function() {
      hasItems = _this.get('cartItems.length') > 0;
    });

    return hasItems;
  },

  private: {
    sumPrice: function(attribute) {
      return this.get('cartItems').getEach(attribute).reduce(function(accum, item) {
        return accum + item;
      }, 0);
    }
  }
});
