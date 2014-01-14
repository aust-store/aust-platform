var setupStore = function(options) {
  var env = {};
  options = options || {};

  var container = env.container = new Ember.Container();

  var adapter = env.adapter = (options.adapter || DS.Adapter);
  delete options.adapter;

  var store = (options.store || DS.Store);

  for (var prop in options) {
    container.register('model:' + prop, options[prop]);
  }

  container.register('store:main', store.extend({
    adapter: adapter
  }));

  container.register('serializer:_default', DS.JSONSerializer);
  container.register('serializer:_rest', DS.RESTSerializer);
  container.register('adapter:_rest', DS.RESTAdapter);

  container.injection('serializer', 'store', 'store:main');

  env.serializer = container.lookup('serializer:_default');
  env.restSerializer = container.lookup('serializer:_rest');
  env.store = container.lookup('store:main');
  env.adapter = env.store.get('defaultAdapter');

  return env;
};

/**
 * Used to build an env/container with offline and online stores.
 */
var setupOfflineOnlineStore = function(opts) {
  var env;

  opts["serializer"] = App.ApplicationSerializer;
  opts["adapter"]    = App.ApplicationAdapter;
  env = setupStore(opts);
  registerOnlineStoreIntoContainer(env.container, optionsForOnlineStore);
  env.onlineStore = env.container.lookup('store:online');
  return env;
}

var transforms = {
  'boolean': DS.BooleanTransform.create(),
  'date': DS.DateTransform.create(),
  'number': DS.NumberTransform.create(),
  'string': DS.StringTransform.create()
};

// Prevent all tests involving serialization to require a container
DS.JSONSerializer.reopen({
  transformFor: function(attributeType) {
    return this._super(attributeType, true) || transforms[attributeType];
  }
});

var registerOnlineStoreIntoContainer = function(container, opts) {
  container.register('store:online', opts.store);
  container.register('adapter:'    + opts.registeredName, opts.adapter);
  container.register('serializer:' + opts.registeredName, opts.serializer);
}

var injectOnlineStoreIntoApplication = function(container, application) {
  application.inject('route',      'onlineStore', 'store:online');
  application.inject('controller', 'onlineStore', 'store:online');
  application.inject('serializer', 'onlineStore', 'store:online');

  container.lookup('store:online');
}
