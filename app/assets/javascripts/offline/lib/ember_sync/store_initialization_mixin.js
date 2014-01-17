if (!EmberSync) { var EmberSync = {}; }

EmberSync.StoreInitializationMixin = Ember.Mixin.create({
  init: function() {
    var onlineStore  = this.onlineStore  || this.container.onlineStore,
        offlineStore = this.offlineStore || this.container.store;

    if (this.container) {
      this.set('container', this.container);
    }

    this.set('offlineStore', offlineStore);
    this.set('onlineStore',  onlineStore);
  },

  container: null,
  offlineStore: null,
  onlineStore: null,
});
