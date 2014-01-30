EmberSync.onError = function() {};

EmberSync.API = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  /**
   * Pushes pending record to the server.
   *
   * Whenever you create, updates or deletes a record, a `job` is create in a
   * `queue` in the offline database. Once the internet is available, this queue
   * will be processed and those records will be synchronized with the remote
   * server.
   *
   * This should be called from the ApplicationRoute, e.g.
   *
   *     App.ApplicationRoute = Ember.Route.extend({
   *       init: function() {
   *         this._super();
   *
   *         var emberSync = EmberSync.API.create({container: this});
   *         emberSync.synchronizeOnline();
   *       }
   *     });
   *
   * It will keep running forever (unless otherwise commanded).
   *
   * @method synchronizeOnline
   */
  synchronizeOnline: function() {
    EmberSync.Queue.create({
      offlineStore: this.offlineStore,
      onlineStore:  this.onlineStore,
      onError:      EmberSync.onError
    }).process();
  },

  /**
   * Downloads records for offline caching, so users can use the app without
   * an internet connection.
   *
   * This should be called from the ApplicationRoute, e.g.
   *
   *     App.ApplicationRoute = Ember.Route.extend({
   *       init: function() {
   *         this._super();
   *
   *         var emberSync = EmberSync.API.create({container: this});
   *         emberSync.offlineCache({
   *           models: ['inventoryItem']
   *         });
   *       }
   *     });
   *
   * In this example, we'll be frequently download new records for the
   * `inventoryItem` model. It will keep running all by itself.
   *
   * @method offlineCache
   */
  offlineCache: function(options) {
    // var models = options.models;

    // EmberSync.OfflineCache.create({
    //   offlineStore: this.offlineStore,
    //   onlineStore:  this.onlineStore,
    //   onError:      this.get('onError')
    // }).download();
  },

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
      offlineStore: this.offlineStore,
      onError:      EmberSync.onError
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
      offlineStore: this.offlineStore,
      onError:      EmberSync.onError
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
          offlineStore: this.get('emberSync.offlineStore'),
          onError:      EmberSync.onError
        });

        return persistence.save(this.get('record'));
      }
    });
  }
});

App.EmberSync = EmberSync.API.extend();

