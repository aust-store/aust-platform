Lib.UsableEditor = Ember.Object.create({
  focusCursorOnEditor: function () {
    $(".editor .textareas textarea:visible").focus();
  }
});
