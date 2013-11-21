App.ThemeFileController = Ember.ObjectController.extend({
  saveBody: function() {
    if (this.get('isDirty')) {
      this.get('model').save();
    }
  }.observes('body'),
});
