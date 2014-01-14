App.SearchOnline = Ember.Object.extend({
  init: function() {
    this._super();
    this.set('offlineStore', this.container.store);
    this.set('onlineStore',  this.container.onlineStore);
  },

  container: null,
  offlineStore: null,
  onlineStore: null,

  /**
   * Finds a record through the online store. Then, persists that record
   * offline.
   *
   * Use this just like regular store's `find()`.
   *
   * @method find
   * @param {string} type
   * @param {object} query
   */
  find: function(type, query) {
    var storeSync = this,
        search = this.onlineStore.find(type, query),
        asyncResult = Ember.A();

    search.then(function(results) {
      if (results.get('id') && !results.length) {
        results = Ember.A([results]);
      }

      results.forEach(function(onlineResult) {
        var id = onlineResult.get('id'),
            persistenceState = storeSync.offlineStore.find(type, id);

        var persistRecordOffline = function(onlineRecord) {
          storeSync.persistRecordOffline(type, onlineResult);
        };

        persistenceState.then(persistRecordOffline, persistRecordOffline);
      });
    });

    return search;
  },

  /**
   * This is a method persists a given record found online into the offline
   * store.
   *
   * @method persistRecordOffline
   * @param {string} type
   * @param {DS.Model} record
   */
  persistRecordOffline: function(type, record) {
    var offlineSerializer = this.offlineSerializer(type),
        serialized = offlineSerializer.serialize(record, { includeId: true }),
        model;

    model = this.offlineStore.push(type, serialized);
    model.save();
  },

  offlineSerializer: function(type) {
    return this.offlineStore.serializerFor(type);
  }
});
