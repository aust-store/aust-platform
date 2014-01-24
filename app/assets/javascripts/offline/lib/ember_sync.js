App.EmberSync = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  /**
   * Finds a record both offline and online, returning the first to be found.
   * If an online record is found, it is then pushed into the offline store,
   * which should automatically update the references to the original record
   * (if this was changed).
   *
   * Use this just like regular store's `find()`.
   *
   * @method find
   * @param {string} type
   * @param {object} query
   * @return {Promise}
   */
  find: function(type, query) {
    var syncQuery = EmberSync.Query.create({
      onlineStore:  this.onlineStore,
      offlineStore: this.offlineStore
    });
    return syncQuery.find(type, query);
  },

  /**
   * Queries both online and offline stores simultaneously, returning values
   * asynchronously into a stream of results (Ember.A()).
   *
   * The records found online are stored into the offline store.
   *
   * Use this just like regular store's `findQuery()`. Remember, though, it
   * doesn't return a Promise, but you can use `.then()` even so.
   *
   * @method findQuery
   * @param {string} type
   * @param {object} query
   * @return {Ember.A}
   */
  findQuery: function(type, query) {
    var syncQuery = EmberSync.Query.create({
      onlineStore:  this.onlineStore,
      offlineStore: this.offlineStore
    });
    return syncQuery.findQuery(type, query);
  },

  createRecord: function(type, properties) {
    var _this = this,
        record;

    if (properties) {
      record = this.offlineStore.createRecord(type, properties);
    } else {
      record = this.offlineStore.createRecord(type);
    }

    this.embedThisIntoRecord(record, type, properties);
    return record;
  },

  deleteRecord: function(type, record) {
    record.deleteRecord();
    this.embedThisIntoRecord(record, type);
    return record;
  },

  embedThisIntoRecord: function(record, type, properties) {
    var _this = this;

    record.emberSync = Ember.Object.create({
      init: function() {
        this.set('emberSync',  _this);
        this.set('record',     record);
        this.set('recordType', type);
      },

      save: function() {
        var persistence = EmberSync.Persistence.create({
          onlineStore:  this.get('emberSync.onlineStore'),
          offlineStore: this.get('emberSync.offlineStore')
        });

        return persistence.save(this.get('record'));
      }
    });
  }
});
