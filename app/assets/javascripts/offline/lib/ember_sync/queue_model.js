App.EmberSyncQueueModel = DS.Model.extend({
  jobRecordType: DS.attr('string'),
  jobRecordId:   DS.attr('string'),
  operation:     DS.attr('string'),
  createdAt:     DS.attr('string'),
});
