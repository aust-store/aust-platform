if (!EmberSync) { var EmberSync = {}; }

EmberSync.queueTimer = null;
EmberSync.testing = false;

EmberSync.Queue = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  enqueue: function(type, id, pendingCreation) {
    var job;

    job = this.offlineStore.createRecord('emberSyncQueueModel', {
      jobRecordType:   type,
      jobRecordId:     id,
      pendingCreation: pendingCreation,
      createdAt:       (new Date).toUTCString(),
    });
    adapter = this.offlineStore.adapterFor(type);
    adapter.createRecord(null, App.EmberSyncQueueModel, job);
    job.deleteRecord();
  },

  pendingJobs: Ember.A(),

  process: function() {
    var queue = this,
        jobs;

    jobs = this.offlineStore.find('emberSyncQueueModel');
    jobs.then(function(jobs) {
      /**
       * TODO - shouldn't push duplicated jobs
       */
      queue.set('pendingJobs', Ember.A(jobs));
      queue.processNextJob();
    });
  },

  processNextJob: function(job) {
    var job, jobRecord;

    if (!this.pendingJobs.get('length')) {
      return true;
    }

    jobRecord = this.get('pendingJobs').objectAt(0);

    job = EmberSync.Job.create({
      offlineStore: this.offlineStore,
      onlineStore:  this.onlineStore,
      jobRecord:    jobRecord
    });

    job.perform();
  }
});
