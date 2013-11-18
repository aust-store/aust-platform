//= require jquery

//= require handlebars
// require ./../vendor/moment.min
//= require ./ember.min
//= require ./ember-data.min

//= require_self


//= require ./store
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./helpers
//= require_tree ./templates
//= require ./router
//= require_tree ./routes
//= require_tree ./lib

Ember.LOG_VERSION = false;

if (window.env == 'development') {
  Ember.LOG_VERSION = true;
  App = Ember.Application.create({
    currentRoute: '',
    LOG_TRANSITIONS: true,
    //LOG_TRANSITIONS_INTERNAL: true
  });
} else {
  App = Ember.Application.create({
    currentRoute: '',
  });
}

App = Ember.Application.create({
  resolver: Ember.DefaultResolver.extend({
    resolveTemplate: function(parsedName) {
      parsedName.fullNameWithoutType = "theme_editor/" + parsedName.fullNameWithoutType;
      return this._super(parsedName);
    }
  })
});

//= require_tree .
