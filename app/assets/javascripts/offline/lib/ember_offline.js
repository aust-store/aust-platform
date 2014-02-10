var EmberOfflineTesting = false;

var EmberOffline = Ember.Object.extend({
  isConnected:         true,
  noConnectionMessage: null,
  backOnlineMessage:   null,

  init: function() {
    var _this = this;
    this._super();

    this.set('hideBackOnlineMessageDelay', 5000);
    this.set('showBackOnlineMessageDelay', 500);

    if (!navigator.onLine) {
      this.goOffline();
    }

    if (!EmberOfflineTesting) {
      Em.run.later(function() {
        _this.testServer();
      }, 2000);
    }
    this.addEventListeners();
  },

  testServer: function() {
    var _this = this;

    Em.run.cancel(_this.get('retryTimer'));

    this.statusAjaxRequest().then(function() {
      if (!EmberOfflineTesting) {
        var retryTimer = Em.run.later(function() {
          _this.testServer();
        }, 85000);

        _this.set('retryTimer', retryTimer);
      }

      if (_this.get('isConnected') === true) {
        return true;
      }

      _this.set('isConnected', true);
      _this.set('noConnectionMessage', null);
      _this.setBackOnlineMessage('Servidor voltou ao ar');
    }, function() {
      if (!EmberOfflineTesting) {
        Em.run.later(function() {
          _this.testServer();
        }, 9000);
      }

      if (_this.get('isConnected') === false) {
        return true;
      }
      _this.set('isConnected', false);
      _this.set('noConnectionMessage', 'Servidor fora do ar');
    });
  },

  goOnline: function() {
    var _this = this;

    if (this.get('isConnected')) {
      return true;
    }

    Em.run.later(function() {
      _this.set('isConnected', true);
      _this.set('noConnectionMessage', null);

      _this.setBackOnlineMessage('Internet voltou');
    }, _this.get('showBackOnlineMessageDelay'));
  },

  goOffline: function() {
    this.set('isConnected', false);
    this.set('noConnectionMessage', 'Internet fora do ar');
  },

  addEventListeners: function() {
    var _this = this;

    window.addEventListener('online',  function() {
      Em.run(function() {
        App.emberOffline.goOnline();
      });
    });
    window.addEventListener('offline', function() {
      Em.run(function() {
        App.emberOffline.goOffline();
      });
    });
  },

  statusAjaxRequest: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      Ember.$.get(_this.serverStatusUrl)
        .done(function(data) {
          resolve();
        })
        .fail(function(data) {
          reject();
        });
    });
  },

  setBackOnlineMessage: function(message) {
    var _this = this;

    if (this.get('backOnlineMessage')) {
      return true;
    }

    this.set('backOnlineMessage', message);

    Em.run.later(function() {
      _this.set('backOnlineMessage', null);
    }, this.get('hideBackOnlineMessageDelay'));
  }
});

App.EmberOffline = EmberOffline.extend({
  serverStatusUrl: serverStatusUrl
});
