App.Order = DS.Model.extend
  cart: DS.belongsTo('App.Cart')

App.RESTAdapter.map App.Order,
  cart:
    embedded: "always"
