if (!EmberSync) { var EmberSync = {}; }

EmberSync.Job = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  jobRecord:  null,

  init: function() {
    this._super();
  },

  perform: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      _this.synchronizeOnline().then(function() {
        resolve();
      }, function() {
        reject();
      }, "Aust: job#perform() for jobId "+_this.get('jobRecord.id'));
    });
  },

  synchronizeOnline: function() {
    var recordPromise,
        operation = this.get('jobRecord.operation');

    if (operation == "delete") {
      recordPromise = null;
    } else {
      recordPromise = this.save();
    }

    return this.commitChangesOnline(recordPromise);
  },

  save: function() {
    var _this = this;

    return this.findOfflineRecord().then(function(offlineRecord) {
      var record, recordForSynchronization;

      recordForSynchronization = EmberSync.RecordForSynchronization.create({
        offlineStore:  _this.offlineStore,
        onlineStore:   _this.onlineStore,
        offlineRecord: offlineRecord,
        jobRecord:     _this.get('jobRecord'),
      });

      return recordForSynchronization.toEmberData();
    });
  },

  commitChangesOnline: function(record) {
    var _this = this;

    return record.then(function(record) {
      if (EmberSync.forceSyncFailure) {
        return Ember.RSVP.reject({message: "Forced failure", stack: ":)"});
      } else {
        return record.save();
      }
    }).then(function() {
      return Ember.RSVP.resolve();
    }, function(error) {
      return Ember.RSVP.reject(error);
    }, "Aust: job#synchronizeOnline() for job "+ _this.get('jobRecord.id'));
  },

  findOfflineRecord: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      var record,
          recordType = _this.get('jobRecord.jobRecordType'),
          recordId   = _this.get('jobRecord.jobRecordId');

      if (_this.get('originalOfflineRecord')) {
        resolve(_this.get('originalOfflineRecord'));
        return true;
      }
      record = _this.offlineStore.find(recordType, recordId);
      record.then(function(record) {
        _this.set('originalOfflineRecord', record);
        resolve(record);
      }, function() {
        console.error("Original record doesn't exist anymore");
        console.error(_this);
        reject();
      });
    });
  },

  /**
   * Memoizes the original offline record.
   */
  originalOfflineRecord: null
});
