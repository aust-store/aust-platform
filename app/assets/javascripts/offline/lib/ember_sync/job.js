if (!EmberSync) { var EmberSync = {}; }

EmberSync.Job = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  jobRecord:  null,

  init: function() {
    this._super();

    this.set("recordType", this.get('jobRecord.jobRecordType'));
    this.set("recordId",   this.get('jobRecord.jobRecordId'));
    this.set("operation",  this.get('jobRecord.operation'));
  },

  perform: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {

      _this.findOfflineRecord().then(function(offlineRecord) {
        return _this.synchronizeOnline(offlineRecord);
      }).then(function() {
        resolve();
      }, function() {
        reject();
      }, "Aust: job#perform() for jobId "+_this.get('jobRecord.id'));
    });
  },

  synchronizeOnline: function(offlineRecord) {
    var _this = this,
        record;

    record = EmberSync.RecordForSynchronization.create({
      offlineStore:  this.offlineStore,
      onlineStore:   this.onlineStore,
      offlineRecord: offlineRecord,
      jobRecord:     this.get('jobRecord'),
    }).recordForSynchronization();

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
