DS.CustomActiveModelAdapter = DS.ActiveModelAdapter.extend({
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
    console.log("yay I'm here");
    return DS.CustomActiveModelAdapter.create();
  },

  serializerFor: function(type) {
    return DS.ActiveModelSerializer.create();
  }
});
