var EmberTesting = {
  getStore: function(app) {
    return app.__container__.lookup("store:main");
  },

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
          localAttributes;

      localAttributes = _this.localAttributes().map(function(attr) {
        return Ember.String.decamelize(attr);
      });
      this.assert(function(response) {
        QUnit.deepEqual(localAttributes, response.attributes);
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
      });

      this.assert(function(response) {
        associations = ApplyExceptions(except, response.associations);
        QUnit.deepEqual(localRelationships, associations);
      });
    }

    this.assertFixtures = function() {
      var _this = this;
      this.assert(function(response) {
        _this.model.FIXTURES.forEach(function(fixture) {
          var fields = Object.keys(fixture);
          QUnit.deepEqual(fields, response.attributes);
        });
      });
    }

    this.assert = function(assertion) {
      var _this = this;
      $.get(_this.contractUrl).done(function(response) {
        _this.response = response;

        if (_this.root) {
          _this.response = response[_this.root];
        }

        assertion(_this.response);
        start();
      });
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
