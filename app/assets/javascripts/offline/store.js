var CustomAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'admin/api/v1'
});

App.ApplicationAdapter = CustomAdapter;

App.ApplicationSerializer = DS.ActiveModelSerializer.extend({
  // modelTypeFromRoot: function(root) {
  //   var camelized = Ember.String.camelize(root);
  //   return Ember.String.singularize(camelized);
  // }
});
