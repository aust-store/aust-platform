/**
 * Online-connected store
 */

var registeredNameForOnlineAdapter = "_custom_ams",
    serverStatusUrl = "/pos/api/v1/status";

DS.CustomOnlineSerializer = DS.ActiveModelSerializer.extend({
  init: function() {
    this._super();
    this.set('container', App.__container__);
  }
});
DS.CustomOnlineAdapter = DS.ActiveModelAdapter.extend({
  serializer: DS.CustomOnlineSerializer.create()
});

if (typeof QUnit == "undefined") {
  Ember.Application.initializer({
    name: "onlineStore",

    initialize: function(container, application) {
      var opts = {
        store: DS.OnlineStore,
        registeredName: registeredNameForOnlineAdapter, // _custom_ams
        adapter: DS.CustomOnlineAdapter,
        serializer: DS.CustomOnlineSerializer
      }

      container.register('store:online', opts.store);
      container.register('adapter:' + opts.registeredName, opts.adapter);
      container.register('serializer:' + opts.registeredName, opts.serializer);

      application.inject('route',      'onlineStore', 'store:online');
      application.inject('controller', 'onlineStore', 'store:online');
    }
  });
};
