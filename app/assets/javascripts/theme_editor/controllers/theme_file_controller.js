App.ThemeFileController = Ember.ObjectController.extend({
  saveTimer: null,

  saveBody: function() {
    if (this.get('isDirty')) {
      var _this = this;

      clearTimeout(this.saveTimer);
      this.saveTimer = setTimeout(function() {
        if (_this.get('isDirty')) {
          _this.controllerFor("application").set("appStatus", "Salvando arquivo...");

          _this.get('model').save().then(function() {
            setTimeout(function() {
              _this.controllerFor("application").set("appStatus", "");
            }, 2000);
          });

        }
      }, 4000);
    }
  }.observes('body'),
});
