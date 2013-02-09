App.OrdersIndexController = Ember.ArrayController.extend
  setupController: (controller, model) ->
    controller.set('content', model)

App.OrdersNewController = Ember.ObjectController.extend()
