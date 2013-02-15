App.Cart = DS.Model.extend
  items: DS.hasMany('App.OrderItem')
  subtotal: (->
    this.get('items').getEach('price').reduce (accum, item) ->
      accum + item
    , 0
  ).property('items.@each.price')

App.RESTAdapter.map App.Cart,
  items:
    embedded: "always"
