App.PreviewController = Ember.ObjectController.extend({
  actions: {
    refreshIframe: function() {
      var savingFiles = Ember.A(),
          _this = this;


      this.controllerFor("themeFiles").get('content').forEach(function(item) {
        if (item.get('isDirty')) {
          savingFiles.push(item.save());
        }
      });

      this.controllerFor("application").set("appStatus", "Salvando e atualizando...");

      Ember.RSVP.all(savingFiles).then(function() {
        document.getElementById('preview_element').contentWindow.location.reload(true);
        setTimeout(function() {
          _this.controllerFor("application").set("appStatus", "");
        }, 2000);
      });
    }
  }
});
