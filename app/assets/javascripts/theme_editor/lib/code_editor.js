Lib.CodeEditor = Ember.Object.extend({
  filename: null,
  emberRoute: null,
  language: null,

  /**
   * Editor is an instance of the Ace plugin
   */
  editor: null,

  init: function() {
    this.set("editor", ace.edit(this.domId()));
    this.get("editor").getSession().setUseWorker(false);
    this.get("editor").getSession().setTabSize(2);
    this.get("editor").getSession().setUseSoftTabs(true);
    this.defineLanguage();
    this.defineEvents();
  },

  defineLanguage: function() {
    /**
     * Needed for Ace plugin
     */
    var LanguageMode;

    LanguageMode = require("ace/mode/" + this.language()).Mode;
    this.get("editor").getSession().setMode(new LanguageMode());
  },

  defineEvents: function() {
    var _this = this,
        route = this.get("emberRoute");

    var OnContentChange = function() {
      var controller, content;

      controller = route.controllerFor('themeFiles');
      content = controller.get('content').find(function(item) {
        return item.get("filename") == _this.get("filename");
      });
      content.set("body", _this.value());
    }
    this.get("editor").getSession().on("change", OnContentChange);
  },

  domId: function() {
    return this.get("filename").replace(".", "_");
  },

  value: function() {
    return this.get("editor").getValue();
  },

  language: function() {
    /**
     * Ace editor plugin doesn't have mustache templates, but does have
     * handlebars.
     */
    if (this.get("filename").match(/\.mustache$/)) {
      return "handlebars";
    } else {
      return this.get("filename").match(/\.(.*)/)[1];
    }
  }
});
