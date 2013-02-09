App.Router.reopen
  enableLogging: true
  rootURL: '/'

App.Router.map ->
  this.resource 'orders', ->
    this.route 'new'

App.OrdersIndexRoute = Ember.Route.extend
  model: ->
    App.Order.find()

App.OrdersNewRoute = Ember.Route.extend
  model: ->
    current_model = this.controllerFor('orders_new').get('model')
    current_model or App.Order.createRecord()

  setupController: (controller, model) ->
    this.controllerFor('orders_new').set('content', model)
