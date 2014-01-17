if (!EmberSync) { var EmberSync = {}; }

EmberSync.Persistence = Ember.Object.extend({
  init: function() {
    this._super();
    this.set('offlineStore', this.offlineStore);
    this.set('onlineStore',  this.onlineStore);
  },

  offlineStore: null,
  onlineStore: null,

  /**
   * This is a method persists a given record found online into the offline
   * store.
   *
   * @method persistRecordOffline
   * @param {string} type
   * @param {DS.Model} record
   */
  persistRecordOffline: function(type, record) {
    var offlineSerializer = this.offlineStore.serializerFor(type),
        serialized = offlineSerializer.serialize(record, { includeId: true }),
        model;

    model = this.offlineStore.push(type, serialized);
    return model.save();
  },

});
