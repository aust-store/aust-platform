App.EmberSyncQueueModel = DS.Model.extend({
  jobRecordType:   DS.attr('string'),
  jobRecordId:     DS.attr('string'),
  pendingCreation: DS.attr('boolean'),
  createdAt:       DS.attr('string'),
});
