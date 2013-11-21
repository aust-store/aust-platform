App.ThemeFileController = Ember.ObjectController.extend({
  saveTimer: null,

  saveBody: function() {
    if (this.get('isDirty')) {
      var _this = this;

      clearTimeout(this.saveTimer);
      this.saveTimer = setTimeout(function() {
        _this.get('model').save();
      }, 4000);
    }
  }.observes('body'),
});
