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
        return _this.saveRecordOnline(offlineRecord);
      }).then(function() {
        resolve();
      }, function() {
        reject();
      }, "Aust: job#perform() for jobId "+_this.get('jobId'));
    });
  },

  /**
   * Memoizes the original record.
   */
  originalOfflineRecord: null,
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

  saveRecordOnline: function(offlineRecord) {
    var _this = this,
        existingRecord, record, properties;

    properties = this.propertiesToPersist(offlineRecord);
    var existingRecord = this.onlineStore.hasRecordForId(_this.get('recordType'), _this.get('recordId'));

    if (existingRecord && _this.get('pendingCreation')) {
      record = this.onlineStore.recordForId(this.get('recordType'), properties.id);
      console.log('dirty?', record.get('isDirty'));
      this.onlineStore.unloadRecord(record);
    }

    if (_this.get('pendingCreation')) {
      record = this.onlineStore.createRecord(this.get('recordType'), properties);
    } else {
      record = this.onlineStore.push(this.get('recordType'), properties);
    }

    this.setHasManyRelationships(record).then(function(record) {
      return _this.setBelongsToRelationships(record);
    }).then(function(record) {
      return record.save();
    }).then(function() {
      return Ember.RSVP.resolve();
    }, function(error) {
      _this.errors.recordNotSynchronized.call(_this, error);
      return Ember.RSVP.reject();
    });
  },

  propertiesToPersist: function(record) {
    var properties = record.serialize();
    properties["id"] = this.get('recordId');

    record.eachRelationship(function(relationship) {
      delete properties[relationship];
    });

    return properties;
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

  errors: {
    recordNotSynchronized: function(error) {
      console.error(this.get('recordType')+" with id "+this.get('jobRecord.id')+" couldn't be saved online. "+error.message);
      console.error(error.stack);
    },
  }
});
