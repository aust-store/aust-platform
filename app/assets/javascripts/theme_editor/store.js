CustomRESTAdapter = DS.RESTAdapter.extend({
  namespace: 'api',
  pathForType: function(type) {
    var underscored = Ember.String.underscore(type)
    return Ember.String.pluralize(underscored);
  },
});

var hstoreTransformation = {
  serialize: function(value) {
    var object = new Object;
    value.get('fields').forEach(function(field) {
      object[field] = value.get('values')[field];
    });
    return object;
  },

  deserialize: function(value) {
    var index = 0,
        methods = new Object,
        mixin,
        fields = new Array(),
        values = new Array();


    for (field in value) {
      fields.push(field);
      values.push(value[field]);
      methods[field] = value[field];
      index = index + 1;
    }

    methods.fields = fields;
    methods.values = values;

    mixin = Ember.Object.extend(methods);
    return mixin.create();
  }
};


App.ApplicationAdapter = CustomRESTAdapter;

App.ApplicationSerializer = DS.RESTSerializer.extend({
  modelTypeFromRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    return Ember.String.singularize(camelized);
  }
});

App.HstoreTransform = DS.Transform.extend(hstoreTransformation);
