App.Router.reopen
  enableLogging: true
  rootURL: '/'

App.Router.map ->
  this.resource 'carts', ->
    this.route 'new'
  this.resource 'orders', ->

App.CartsIndexRoute = Ember.Route.extend
  model: ->
    App.Cart.find()

App.CartsNewRoute = Ember.Route.extend
  model: ->
    current_model = this.controllerFor('carts.new').get('model')
    current_model or App.Cart.createRecord()

  setupController: (controller, model) ->
    controller.set('content', model)

App.OrdersIndexRoute = Ember.Route.extend
  model: ->
    App.Order.find environment: "offline"
