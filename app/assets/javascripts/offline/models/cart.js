App.Cart = DS.Model.extend({
  total: DS.attr('string'),
  items: DS.hasMany('cartItem'),

  subtotal: function() {
    return this.get('items').getEach('price').reduce(function(accum, item) {
      return accum + item;
    }, 0);
  }.property('items.@each.price'),
});

/*
App.RESTAdapter.map(App.Cart, {
  items: {
    embedded: "always"
  }
});
*/
