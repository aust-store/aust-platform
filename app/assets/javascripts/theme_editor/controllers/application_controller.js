App.ApplicationController = Ember.ObjectController.extend({
  appStatus: "",
  appStatusTimer: null,

  resetAppStatus: Ember.observer(function() {
    var _this = this;

    if (this.get("appStatus") === "") {
      $("#app_status").hide();
    } else {
      $("#app_status").show();
    }

    clearTimeout(this.saveTimer);
    this.appStatusTimer = setTimeout(function() {
      _this.set('appStatus', '');
    }, 10000);

  }, "appStatus")
});
