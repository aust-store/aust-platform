/**
 * Online-connected store
 */
Ember.Application.initializer({
  name: "onlineStore",

  initialize: function(container, application) {
    container.register('store:online', DS.OnlineStore);
    application.inject('route', 'onlineStore', 'store:online');
  }
});

