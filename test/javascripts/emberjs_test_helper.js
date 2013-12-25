var EmberTesting = {
  getStore: function(app) {
    return app.__container__.lookup("store:main");
  },

  remoteCallsCache: {},

  modelContract: function(options) {
    this.model           = options.model,
    /**
     * Root element of the JSON response, if any
     */
    this.root            = options.root || null,
    this.contractUrl     = options.contractUrl;
    this.response        = null;

    this.assertAttributes = function() {
      var _this = this,
          localAttributes,
          remoteAttributes;

      localAttributes = _this.localAttributes().map(function(attr) {
        return Ember.String.decamelize(attr);
      }).sort();

      this.assert(function(response) {
        QUnit.deepEqual(localAttributes, response.attributes.sort());
      });
    }

    this.assertAssociations = function(options) {
      var _this  = this,
          except,
          localRelationships;

      if (options) {
        except = options.except;
      }

      /**
       * if an exception was passed in it, it means the contract should
       * disregard this exception.
       */
      var ApplyExceptions = function(except, array) {
        if (except) {
          except.forEach(function(exception) {
            var index = array.indexOf(exception);
            if (index >= 0)
              array = array.slice(index+1);
          })
        }
        return array;
      }

      localRelationships = ApplyExceptions(except, _this.localRelationships());

      localRelationships = localRelationships.map(function(association) {
        return Ember.String.decamelize(association);
      }).sort();

      this.assert(function(response) {
        associations = ApplyExceptions(except, response.associations);
        QUnit.deepEqual(localRelationships, associations.sort());
      });
    }

    this.assertFixtures = function() {
      var _this = this;
      this.assert(function(response) {
        if (typeof _this.model.FIXTURES === 'undefined') {
          ok(true);
          return true;
        }

        _this.model.FIXTURES.forEach(function(fixture) {
          var fields = Object.keys(fixture);
          QUnit.deepEqual(fields.sort(), response.attributes.sort());
        });
      });
    }

    this.assert = function(assertion) {
      var _this = this,
          AssertResponse;

      AssertResponse = function(response) {
        if (_this.root) {
          response = response[_this.root];
        }

        assertion(response);
        start();
      }

      if (typeof EmberTesting.remoteCallsCache[_this.contractUrl] === 'undefined') {
        $.get(_this.contractUrl).done(function(response) {
          EmberTesting.remoteCallsCache[_this.contractUrl] = response;
          AssertResponse(response);
        });
      } else {
        response = EmberTesting.remoteCallsCache[_this.contractUrl];
        AssertResponse(response);
      }
    };

    this.localAttributes = function() {
      var _this = this,
          attributes = [];

      attributes = [];
      attributes.push("id");
      Ember.get(this.model, 'attributes').forEach(function(name, meta) {
        attributes.push(name);
      });
      return attributes;
    };

    this.localRelationships = function() {
      var _this = this,
          relationships = [];

      Ember.get(this.model, 'fields').forEach(function(name, kind) {
        if (kind.match("hasMany|belongsTo|hasOne")) {
          relationships.push(name);
        }
      });
      return relationships;
    };

    return this;
  }
}
