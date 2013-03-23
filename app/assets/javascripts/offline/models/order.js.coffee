App.Order = DS.Model.extend
  cart: DS.belongsTo('App.Cart')
  total: DS.attr('number')
  items: DS.hasMany('App.OrderItem')
  created_at: DS.attr('string')

App.RESTAdapter.map App.Order,
  cart:
    embedded: "always"
