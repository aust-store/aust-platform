/**
 * This OnlineStore is added to Ember container via initialization/store.js
 */
DS.CustomOnlineAdapter.reopen({
  namespace: 'admin/api/v1'
});

/**
 * This is the store that accesses online data. The initializers define that
 * you should call this in the routers/controllers like so:
 *
 *     this.onlineStore
 *
 *     e.g this.onlineStore.find('customer', 1)
 */
DS.OnlineStore = DS.Store.extend({
  adapterFor: function(type) {
    return this.container.lookup('adapter:' + registeredNameForOnlineAdapter);
  },

  serializerFor: function(type) {
    return this.container.lookup('serializer:' + registeredNameForOnlineAdapter);
  }
});
