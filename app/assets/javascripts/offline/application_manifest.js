//= require jquery
//= require ./handlebars
//= require ./ember
//= require ./ember-states
//= require ./ember-data
//= require_self
//= require ./store
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

function cl(str) { console.log(str); }
