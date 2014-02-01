//= require jquery
//= require ./handlebars
//= require ./ember
//= require ./ember-states
//= require ./ember-data
//= require_tree ./vendor/
//= require_self

//= require ./initialization/application
//= require ./initialization/config
//= require ./initialization/debugging_helpers
//= require ./initialization/online_store
//= require_tree ./initialization

//= require ./store/online_store
//= require ./store/offline_store
//= require_tree ./store

//= require ./lib/ember_sync/store_initialization_mixin
//= require_tree ./lib/ember_sync/
//= require_tree ./lib/
//= require_tree ./routes
//= require_tree ./helpers/
//= require_tree ./controllers/mixins
//= require_tree ./controllers/
//= require_tree ./models/
//= require_tree ./views/mixins
//= require_tree ./views/
//= require ./templates/index
//= require_tree ./templates/

if (!Ember.testing && typeof QUnit == 'undefined') {
  window.developmentHelpers = false;
}

//Ember.RSVP.configure('onerror', function(error) {
//  Ember.Logger.assert(false, error);
//});
