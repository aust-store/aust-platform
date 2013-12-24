var CustomRESTAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'admin/api/v1'
});

//App.RESTAdapter.configure "plurals",
//  orders_statistics: 'orders_statistics'

App.ApplicationAdapter = CustomRESTAdapter;

App.ApplicationSerializer = DS.ActiveModelSerializer.extend({
  // modelTypeFromRoot: function(root) {
  //   var camelized = Ember.String.camelize(root);
  //   return Ember.String.singularize(camelized);
  // }
});
