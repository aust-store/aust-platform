if (!EmberSync) { var EmberSync = {}; }

EmberSync.queueTimer = null;
EmberSync.testing = false;
EmberSync.supressConsoleErrors = true;
EmberSync.forceSyncFailure = false;

EmberSync.Queue = Ember.Object.extend(
  EmberSync.StoreInitializationMixin, {

  init: function() {
    this._super();
    this.set('pendingJobs', Ember.A());
    this.set('retryOnFailureDelay', 3000);
  },

  retryOnFailureDelay: null,

  enqueue: function(type, id, operation) {
    var job;

    job = this.offlineStore.createRecord('emberSyncQueueModel', {
      jobRecordType:   type,
      jobRecordId:     id,
      operation:       operation,
      createdAt:       (new Date).toUTCString(),
    });
    adapter = this.offlineStore.adapterFor(type);
    adapter.createRecord(null, App.EmberSyncQueueModel, job);
    job.deleteRecord();
  },

  pendingJobs: null,

  process: function() {
    var _this = this,
        jobs;

    jobs = this.offlineStore.find('emberSyncQueueModel');
    jobs.then(function(jobs) {
      /**
       * TODO - shouldn't push duplicated jobs
       */
      _this.set('pendingJobs', Ember.A(jobs));
      _this.processNextJob();
    }, function() {
      Em.run.later(function() {
        _this.process();
      }, 500);
    });
  },

  processNextJob: function(job) {
    var _this = this,
        job, jobRecord;

    /**
     * TODO - If there are no jobs, we should not return, but continue the
     * loop.
     */
    if (!this.get('pendingJobs.length')) {
      if (!EmberSync.testing) {
        Em.run.later(function() {
          _this.process();
        }, 1500);
      }
      return true;
    }

    jobRecord = this.get('pendingJobs').objectAt(0);

    job = EmberSync.Job.create({
      offlineStore: this.offlineStore,
      onlineStore:  this.onlineStore,
      jobRecord:    jobRecord
    });

    job.perform().then(function() {
      _this.removeJobFromQueue(jobRecord).then(function() {
        Em.run(function() {
          _this.processNextJob();
        });
      });
    }, function() {
      if (!EmberSync.supressConsoleErrors) {
        console.error("Queue: job #"+jobRecord.get('id')+" not performed.");
      }

      if (!EmberSync.testing) {
        Em.run.later(function() {
          _this.processNextJob();
        }, _this.get('retryOnFailureDelay'));
      }
    }, "Aust: queue#processNextJob() for jobId "+jobRecord.id);
  },

  removeJobFromQueueArray: function(job) {
    var newQueue;

    newQueue = this.get('pendingJobs').reject(function(pendingJob) {
      return pendingJob.get('id') == job.get('id');
    });

    this.set('pendingJobs', newQueue);
  },

  removeJobFromQueue: function(job) {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      job.destroyRecord().then(function() {
        _this.removeJobFromQueueArray(job);
        resolve();
      }, function() {
        console.error('Error deleting EmberSync job #'+job.get('id'));
        reject();
      });
    });
  },
});
