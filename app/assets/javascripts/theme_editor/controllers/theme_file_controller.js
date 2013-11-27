App.ThemeFileController = Ember.ObjectController.extend({
  textareaId: function() {
    return this.get('filename').replace(/\./, "_");
  }.property(),

  saveTimer: null,

  saveBody: function() {
    if (this.get('isDirty')) {
      var _this = this,
          applicationController = _this.controllerFor("application");

      clearTimeout(this.saveTimer);

      this.saveTimer = setTimeout(function() {
        if (_this.get('isDirty')) {
          applicationController.set("appStatus", "Salvando arquivo...");

          var ShowSuccessStatus = function() {
            setTimeout(function() {
              applicationController.set("appStatus", "");
            }, 2000);
          }
          var ShowErrorStatus = function() {
            applicationController.set("appStatus", "Não foi possível salvar o arquivo.");
          }

          _this.get('model').save().then(ShowSuccessStatus, ShowErrorStatus);
        }
      }, 4000);
    }
  }.observes('body'),
});
