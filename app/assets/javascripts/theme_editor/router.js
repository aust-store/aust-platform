App.Router.map(function() {
  this.resource('editor', function() {
    this.route('show');
  });
});

App.LoadingRoute = Ember.Route.extend();

App.ApplicationRoute = Ember.Route.extend({
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    return this.transitionTo("editor");
  }
});

App.EditorRoute = Ember.Route.extend({
  renderTemplate: function() {
    var controller = this.controllerFor("themeFiles");

    this.render('editor.index', {
      outlet: "editor"
    });
  }
});

App.EditorIndexRoute = Ember.Route.extend({
  activate: function() {
  },

  model: function() {
    var themeFilesController = this.controllerFor("themeFiles"),
        previewController = this.controllerFor("preview"),
        themeFiles = this.store.findQuery('theme_file', {theme_id: themeId});

    themeFilesController.set("content", themeFiles);
    previewController.set("content", themeFiles);

    return themeFiles;
  },

  renderTemplate: function() {
    var themeFilescontroller = this.controllerFor("themeFiles");
    var previewController = this.controllerFor("preview");

    this.render('theme_files', {
      into: "editor.index",
      outlet: "theme_files",
      controller: themeFilescontroller
    });

    this.render('preview', {
      outlet: "preview",
      controller: previewController
    });
  },

  afterModel: function() {
    var _this = this;

    Ember.run.next(function() {
      $("a.tab:first").addClass('current');
      $(".textarea.file_editor:first").show();

      _this.controllerFor('themeFiles').get('content').forEach(function(item) {
        Lib.CodeEditor.create({
          filename: item.get("filename"),
          emberRoute: _this,
        });
      });
    });
  }
});
