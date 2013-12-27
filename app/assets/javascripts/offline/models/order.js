App.Order = DS.Model.extend({
  total:       DS.attr('number'),
  createdAt:   DS.attr('string'),
  environment: DS.attr('string'),
  cart:        DS.belongsTo('cart'),
  items:       DS.hasMany('orderItem'),
});
