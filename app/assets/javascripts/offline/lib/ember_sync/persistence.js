if (!EmberSync) { var EmberSync = {}; }

EmberSync.Persistence = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  /**
   * Saves a record offline and adds the synchronization to the queue.
   *
   * The record must have been created using EmberSync.createRecord().
   *
   * @method save
   * @param {DS.Model} record
   */
  save: function(record) {
    var _this = this,
        operation      = this.persistenceOperation(record),
        offlinePromise = record.save(),
        type           = record.emberSync.get('recordType'),
        properties     = record.emberSync.get('recordProperties') || {},
        isNew          = record.get('isNew');

    offlinePromise.then(function(offlineRecord) {
      var onlineRecord, job;

      properties = offlineRecord.serialize({includeId: true});

      queue = EmberSync.Queue.create({
        onlineStore:  _this.onlineStore,
        offlineStore: _this.offlineStore
      });
      return queue.enqueue(type, properties, operation);
    });

    return offlinePromise;
  },

  /**
   * Persists a given record found online into the offline store.
   *
   * @method persistRecordOffline
   * @param {string} type
   * @param {DS.Model} record
   */
  persistRecordOffline: function(type, record) {
    var offlineSerializer = this.offlineStore.serializerFor(type),
        serialized = offlineSerializer.serialize(record, { includeId: true }),
        model, recordForSynchronization;

    recordForSynchronization = EmberSync.RecordForSynchronization.create();
    recordForSynchronization.setDateObjectsInsteadOfDateString(record, serialized);

    model = this.offlineStore.push(type, serialized);
    return model.save();
  },

  persistenceOperation: function(record) {
    if (record.get('currentState.stateName') == "root.deleted.uncommitted") {
      return "delete";
    } else if (record.get('isNew')) {
      return "create";
    } else {
      return "update";
    }
  },
});
