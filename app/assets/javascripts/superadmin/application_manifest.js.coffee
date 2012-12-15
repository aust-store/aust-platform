#= require jquery
#= require jquery_ujs
#= require ./../handlebars
#= require ./../ember
#= require ./../ember-data

#= require_self
#= require_tree ./models
#= require_tree ./routes
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates

window.App = Ember.Application.create(
  autoinit: false,
  ready: ->

)

App.store = DS.Store.create(
  revision: 10,
  adapter: DS.RESTAdapter.create(
    namespace: 'superadmin'
    plurals:
      'company': 'companies'
  )
)

$ -> App.initialize() if typeof mocha == "undefined"
