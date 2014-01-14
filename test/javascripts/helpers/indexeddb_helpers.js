IDB = {};

IDB.deleteDatabase = function(dbName) {
  return new Ember.RSVP.Promise(function(resolve, reject) {
    var deletion = indexedDB.deleteDatabase(dbName);
    deletion.onsuccess = function() {
      Em.run(function() {
        resolve();
      });
    }
    deletion.onerror = function() {
      Em.run(function() {
        cl('Error deleting database ' + dbName);
        reject();
      });
    }
  });
}
