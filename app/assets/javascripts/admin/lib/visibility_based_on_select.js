var VisibilityBasedOnSelect = {
  observe: function() {
    var _this = this;

    $("[data-visible-by-select]").each(function(index, element) {
      var element = $(element),
          select = $(element.data("visible-by-select")),
          valueForVisible = element.data("visible-on-value");

      function defineElement() {
        return _this.defineVisibility(element,
                                      select.val(),
                                      valueForVisible);
      }
      select.change(defineElement);
      defineElement();
    });
  },

  defineVisibility: function(element, value, valueForVisible) {
    if (value == valueForVisible) {
      element.show();
    } else {
      element.hide();
    }
  }
}

$(document).ready(function() {
  VisibilityBasedOnSelect.observe();
});
