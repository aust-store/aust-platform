App.RESTAdapter = DS.RESTAdapter.extend
  namespace: 'admin/api/v1'

App.RESTAdapter.configure "plurals",
  orders_statistics: 'orders_statistics'

App.ReportsAdapter = App.RESTAdapter.extend
  namespace: 'admin/api/v1/reports'

App.Store = DS.Store.extend
  revision: 11
  adapter: App.RESTAdapter
