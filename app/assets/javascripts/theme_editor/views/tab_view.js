App.TabView = Ember.View.extend({
  tagName: "a",
  classNames: ["tab"],
  attributeBindings: ["dataForId:data-for-id", "href"],
  href: "#",

  click: function(e) {
    var fileId = this.get('dataForId');

    Ember.run.next(function() {
      $("a.tab").removeClass("current");
      $(e.target).addClass("current");
      $(".textarea.file_editor").hide();
      $(".textarea.file_editor[data-id='"+fileId+"']").show();
      Lib.UsableEditor.focusCursorOnEditor();
    });

    e.preventDefault();
  }
});
