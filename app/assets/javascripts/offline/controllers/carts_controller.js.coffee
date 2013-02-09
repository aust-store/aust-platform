App.CartsIndexController = Ember.ArrayController.extend
  setupController: (controller, model) ->
    controller.set('content', model)

App.CartsNewController = Ember.ObjectController.extend()
