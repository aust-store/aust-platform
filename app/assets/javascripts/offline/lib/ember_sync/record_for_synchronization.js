if (!EmberSync) { var EmberSync = {}; }

EmberSync.RecordForSynchronization = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  jobRecord:  null,

  init: function() {
    this._super();
  },

  recordForSynchronization: function() {
    var _this = this,
        record;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      record = _this.createRecordInStore();
      record = _this.setRelationships(record);
      resolve(record);
    });
  },

  createRecordInStore: function() {
    var type = this.get('jobRecord.jobRecordType'),
        record, properties;

    properties = this.propertiesToPersist();

    this.rollbackExistingRecord();

    if (this.get('jobRecord.pendingCreation')) {
      record = this.onlineStore.createRecord(type, properties);
    } else {
      record = this.onlineStore.push(type, properties);
    }

    return record;
  },

  rollbackExistingRecord: function() {
    var existingRecord,
        recordId   = this.get('jobRecord.jobRecordId'),
        recordType = this.get('jobRecord.jobRecordType');

    existingRecord = this.onlineStore.hasRecordForId(recordType, recordId);
    if (existingRecord) {
      existingRecord = this.onlineStore.recordForId(recordType, recordId);
      existingRecord.rollback();
      this.onlineStore.unloadAll(recordType);
    } else {
      return false;
    }
  },

  propertiesToPersist: function() {
    var offlineRecord = this.get('offlineRecord'),
        properties = this.serializeWithoutRelationships(offlineRecord);

    properties["id"] = this.get('jobRecord.jobRecordId');
    return properties;
  },

  setRelationships: function(pendingRecord) {
    var _this = this,
        offlineRecord = this.get('offlineRecord');

    offlineRecord.eachRelationship(function(name, descriptor) {
      var key = descriptor.key,
          kind = descriptor.kind,
          type = descriptor.type,
          relation, onlineRelation;

      /**
       * TODO - implement for when `.get(relation)` returns a Promise.
       */
      relation = offlineRecord.get(name);

      if (kind == "belongsTo") {
        if (relation) {
          onlineRelation = _this.generateRelationForRecord(type, relation);
          pendingRecord.set(key, onlineRelation);
        }
      } else if (kind == "hasMany") {
        relation.forEach(function(relation) {
          onlineRelation = _this.generateRelationForRecord(type, relation);
          pendingRecord.get(name).pushObject(onlineRelation);
        });
      }
    });

    return pendingRecord;
  },

  generateRelationForRecord: function(type, relation) {
    var serializedRelation = this.serializeWithoutRelationships(relation);
    return this.onlineStore.push(type.typeKey, serializedRelation);
  },

  serializeWithoutRelationships: function(record) {
    var serialized = record.serialize({includeId: true});

    record.eachRelationship(function(name, descriptor) {
      delete serialized[name];
    });

    return serialized;
  },
});

