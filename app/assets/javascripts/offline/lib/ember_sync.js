App.EmberSync = Ember.Object.extend({
  init: function() {
    this._super();
    this.set('offlineStore', this.container.store);
    this.set('onlineStore',  this.container.onlineStore);
  },

  container: null,
  offlineStore: null,
  onlineStore: null,

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
});
