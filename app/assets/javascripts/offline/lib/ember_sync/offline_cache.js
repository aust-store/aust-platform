if (!EmberSync) { var EmberSync = {}; }

/**
 * Offline cache is achieved via two independent processes:
 *
 *   - CacheConstruction (CC): on first use of the software, a thorough
 *     download of online records is made. There are multiple strategies for
 *     deciding which records are going to be downloaded, being the simplest
 *     the one where all records are downloaded.
 *
 *     This is run only once, when the software is first used. After the
 *     request, a log for specific to CC is saved.
 *
 *   - CacheUpdate (CU): runs everyday and downloads records from online server
 *     in order to update the current offline cache. After each request, it
 *     saves a log with the results, including current date, current page and
 *     others.
 *
 *     It requests from the server records that were updated since the last
 *     request. If there are no logs, it loads CacheConstruction's logs to know
 *     when we requested the last time.
 *
 */
EmberSync.OfflineCache = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  syncTimer: null,

  init: function() {
    this._super();
    this.set('queryInterval', 2000);
  },

  download: function() {
    var _this = this,
        syncTimer;

    syncTimer = Em.run.later(function() {
      _this.requestServer();
    }, this.get('queryInterval'));

    this.set('syncTimer', syncTimer);
  },

  requestServer: function() {
    console.log("#requestServer");
    var query = Ember.Query.create({
      offlineStore: this.offlineStore,
      onlineStore:  this.onlineStore
    });
  }
});
