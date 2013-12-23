App.Order = DS.Model.extend({
  total:       DS.attr('number'),
  created_at:  DS.attr('string'),
  environment: DS.attr('string'),
  cart:        DS.belongsTo('cart'),
  items:       DS.hasMany('order_item'),
});

// FIXME - clean this up
//
// App.RESTAdapter.map App.Order,
//   cart:
//     embedded: "always"
