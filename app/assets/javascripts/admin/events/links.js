$(document).ready(function() {
  $("a.js_another_window").click(function() {
    window.open($(this).attr('href'));
    return false;
  });

  $("a[data-toggle]").click(function() {
    var forToggling = $($(this).data("toggle"));

    forToggling.toggle();
  });
});

