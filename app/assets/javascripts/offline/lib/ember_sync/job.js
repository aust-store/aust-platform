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
    this.set("pendingCreation", this.get('jobRecord.pendingCreation'));
    this.set("jobId",      this.get('jobRecord.id'));
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
      }, "Aust: job#perform() for jobId "+_this.get('jobId'));
    });
  },

  findOfflineRecord: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      var record;

      if (_this.get('originalOfflineRecord')) {
        resolve(_this.get('originalOfflineRecord'));
        return true;
      }
      record = _this.offlineStore.find(_this.get('recordType'), _this.get('recordId'));
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

  synchronizeOnline: function(offlineRecord) {
    var _this = this,
        record;

    record = EmberSync.RecordForSynchronization.create({
      offlineStore: this.offlineStore,
      onlineStore:  this.onlineStore,

      offlineRecord: offlineRecord,
      recordType: this.get('recordType'),
      recordId:   this.get('recordId'),
      pendingCreation: this.get('pendingCreation'),
      jobId:      this.get('jobId'),
    }).recordForSynchronization();

    //record = this.prepareRecordForSynchronization(offlineRecord);

    return this.setHasManyRelationships(record).then(function(record) {
      return _this.setBelongsToRelationships(record);
    }).then(function(record) {
      if (EmberSync.forceSyncFailure) {
        return Ember.RSVP.reject({message: "Forced failure", stack: ":)"});
      } else {
        return record.save();
      }
    }).then(function() {
      return Ember.RSVP.resolve();
    }, function(error) {
      _this.errors.recordNotSynchronized.call(_this, error);
      return Ember.RSVP.reject(error);
    }, "Aust: job#synchronizeOnline() for job "+ _this.getJobId());
  },

  setBelongsToRelationships: function(pendingRecord) {
    var _this = this;

    return this.findOfflineRecord().then(function(offlineRecord) {
      offlineRecord.eachRelationship(function(name, descriptor) {
        var key = descriptor.key,
            kind = descriptor.kind,
            type = descriptor.type,
            serializedRelation, relation, onlineRelation;

        if (kind != "belongsTo") {
          return false;
        }

        relation = offlineRecord.get(name);
        if (relation) {
          serializedRelation = _this.serializeWithoutRelationships(relation);
          onlineRelation = _this.onlineStore.push(type.typeKey, serializedRelation);
          pendingRecord.set(key, onlineRelation);
        }
      });

      return pendingRecord;
    });
  },

  setHasManyRelationships: function(pendingRecord) {
    var _this = this;

    return this.findOfflineRecord().then(function(offlineRecord) {
      offlineRecord.eachRelationship(function(name, descriptor) {
        var key = descriptor.key,
            kind = descriptor.kind,
            type = descriptor.type,
            serializedRelation, relation, onlineRelation;

        if (kind != "hasMany") {
          return false;
        }

        /**
         * TODO - implement for when `.get(relation)` returns a Promise.
         */
        relation = offlineRecord.get(name);
        relation.forEach(function(relation) {
          serializedRelation = _this.serializeWithoutRelationships(relation);
          onlineRelation = _this.onlineStore.push(type.typeKey, serializedRelation);
          pendingRecord.get(name).pushObject(onlineRelation);
        });
      });

      return pendingRecord;
    });
  },

  serializeWithoutRelationships: function(record) {
    var serialized = record.serialize({includeId: true});

    record.eachRelationship(function(name, descriptor) {
      delete serialized[name];
    });

    return serialized;
  },

  getJobId: function() {
    return this.get('jobId');
  },

  errors: {
    recordNotSynchronized: function(error) {
      if (!EmberSync.supressConsoleErrors) {
        console.error(this.get('recordType')+" with id "+this.get('jobRecord.id')+" couldn't be saved online. "+error.message);
      }
    },
  },

  /**
   * Memoizes the original offline record.
   */
  originalOfflineRecord: null,
});
