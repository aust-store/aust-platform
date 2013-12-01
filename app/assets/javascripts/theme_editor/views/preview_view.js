App.PreviewPaneView = Ember.View.extend({
  tagName: "div",
  classNames: ["preview position_absolute"],

  click: function(e) {
    Ember.run.next(function() {
      if ($(e.target).position().left > 200) {
        $(e.target).animate({left: 100}, 400);
      } else {
        $(e.target).animate({left: '100%'}, 400);
      }
    });

    e.preventDefault();
  }
});
