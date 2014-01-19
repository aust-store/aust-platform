if (!EmberSync) { var EmberSync = {}; }

EmberSync.Job = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  recordType: null,
  recordId:   null,
  jobRecord:  null,

  init: function() {
    this._super();

    this.set("recordType", this.get('jobRecord.jobRecordType'));
    this.set("recordId",   this.get('jobRecord.jobRecordId'));
    this.set("jobId",      this.get('jobRecord.id'));
  },

  perform: function() {
    var job = this;

    this.findOfflineRecord().then(function(offlineRecord) {
      job.saveOnline(offlineRecord);
    });
  },

  findOfflineRecord: function() {
    return this.offlineStore.find(this.get('recordType'), this.get('recordId'));
  },

  saveOnline: function(offlineRecord) {
    var job = this,
        onlineRecord, properties;

    properties = offlineRecord.serialize();
    properties["id"] = this.get('recordId');

    delete properties.customer;

    onlineRecord = this.onlineStore.createRecord(this.get('recordType'), properties);

    onlineRecord.save().then(function() {
      job.destroy();
    }, function() {
      job.errors.recordNotSynchronized;
    });
  },

  destroy: function() {
    this.get('jobRecord').destroyRecord().then(null, function() {
      console.error('Error deleting EmberSync job #'+job.get('jobRecord.id'));
    });
  },

  errors: {
    recordNotSynchronized: function(error) {
      console.error(this.get('type')+" with id "+this.get('jobRecord.id')+" couldn't be saved online. "+error.message);
      console.error(error.stack);
    },
  }
});
