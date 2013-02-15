#= require jquery
#= require ./handlebars
#= require ./ember
#= require ./ember-data
#= require_self
#= require ./store
#= require ./routes
#= require_tree ./helpers/
#= require_tree ./controllers/
#= require_tree ./models/
#= require_tree ./views/
#= require ./templates/index
#= require_tree ./templates/

window.App = Ember.Application.create
  ready: ->
    console.log "App is running"
    console.log Ember.TEMPLATES

App.ApplicationView = Ember.View.extend
  templateName: 'offline/templates/application'

window.attr = DS.attr
