//= require jquery
//= require ./handlebars
//= require ./ember
//= require ./ember-states
//= require ./ember-data
//= require_tree ./vendor/
//= require_self

//= require ./store/online_store
//= require ./store/offline_store
//= require ./store/initializers
//= require_tree ./store

//= require ./routes
//= require_tree ./helpers/
//= require_tree ./controllers/
//= require_tree ./models/
//= require_tree ./views/
//= require ./templates/index
//= require_tree ./templates/

var attr = DS.attr,
App = Ember.Application.create({
  LOG_TRANSITIONS: true
});

/**
 * used in Em.run.later(), e.g deferring search when user types characters
 */
App.defaultSearchDelay = 400;

function cl(str) { console.log(str); }
