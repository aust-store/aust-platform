App.RESTAdapter = DS.RESTAdapter.extend
  namespace: 'admin/api/v1'

App.Store = DS.Store.extend
  revision: 11
  adapter: App.RESTAdapter
