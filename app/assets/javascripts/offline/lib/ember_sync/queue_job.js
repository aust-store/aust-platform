if (!EmberSync) { var EmberSync = {}; }

EmberSync.QueueJob = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  enqueue: function(type, id, pendingCreation) {
    var job;

    job = this.offlineStore.createRecord('emberSyncQueueModel', {
      jobRecordType:   type,
      jobRecordId:     id,
      pendingCreation: pendingCreation,
      createdAt:       (new Date).toUTCString(),
    });
    adapter = this.offlineStore.adapter.create();
    adapter.createRecord(null, App.EmberSyncQueueModel, job);
    job.deleteRecord();

    // job.save().then(null, function(error) {
    //   console.error(type, " with id ", id, " couldn't be enqueued. ", error.message);
    //   console.error(error.stack);
    // });
  }
});
