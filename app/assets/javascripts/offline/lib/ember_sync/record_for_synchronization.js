if (!EmberSync) { var EmberSync = {}; }

EmberSync.RecordForSynchronization = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  pendingCreation:  null,
  recordType: null,
  recordId:   null,
  jobRecord:  null,

  init: function() {
    this._super();

    //this.set("offlineRecord", this.get('offlineRecord'));
    this.set("recordType", this.get('recordType'));
    this.set("recordId",   this.get('recordId'));
    this.set("pendingCreation", this.get('pendingCreation'));
    this.set("jobId",      this.get('jobId'));
  },

  recordForSynchronization: function() {
    var record;

    record = this.createRecordInStore();
    return record;
  },

  createRecordInStore: function() {
    var existingRecord, record, properties;

    properties = this.propertiesToPersist();

    var existingRecord = this.onlineStore.hasRecordForId(this.get('recordType'), this.get('recordId'));
    if (existingRecord) {
      existingRecord = this.onlineStore.recordForId(this.get('recordType'), properties.id);
      existingRecord.rollback();
      this.onlineStore.unloadAll(this.get('recordType'));
    }

    if (this.get('pendingCreation')) {
      record = this.onlineStore.createRecord(this.get('recordType'), properties);
    } else {
      record = this.onlineStore.push(this.get('recordType'), properties);
    }

    return record;
  },

  propertiesToPersist: function() {
    var offlineRecord = this.get('offlineRecord'),
        properties = offlineRecord.serialize();

    properties["id"] = this.get('recordId');

    offlineRecord.eachRelationship(function(relationship) {
      delete properties[relationship];
    });

    return properties;
  },
});

