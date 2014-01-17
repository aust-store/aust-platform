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
        offlinePromise = record.save(),
        type       = record.emberSync.recordType,
        properties = record.emberSync.recordProperties || {};

    offlinePromise.then(function(offlineRecord) {
      var onlineRecord;
      properties["id"] = offlineRecord.get('id');

      //return EmberSync.Queue.enqueue(type, offlineId);
      onlineRecord = _this.onlineStore.createRecord(type, properties);
      // offlineRecord.get("cartItems").forEach(function(relationship) {
      //   onlineRecord.get("cartItems").pushObject(relationship);
      // });

      onlineRecord.save();
    });

    return offlinePromise;
  },

  /**
   * This is a method persists a given record found online into the offline
   * store.
   *
   * @method persistRecordOffline
   * @param {string} type
   * @param {DS.Model} record
   */
  persistRecordOffline: function(type, record) {
    var offlineSerializer = this.offlineStore.serializerFor(type),
        serialized = offlineSerializer.serialize(record, { includeId: true }),
        model;

    model = this.offlineStore.push(type, serialized);
    return model.save();
  },

});
