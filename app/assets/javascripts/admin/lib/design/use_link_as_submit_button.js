function replaceSubmitButtons() {
  $("input[type='submit']").each(function() {
    var btn   = $(this),
        label = btn.val();
    btn.replaceWith('<a href="#" class="js_submit_button btn" name="submit">'+label+'</a>');
  });
}

$(document).ready(function() {
  replaceSubmitButtons();

  $("a.js_submit_button").on("click", function() {
    $(this).parents("form").submit();
    return false;
  });

  $('form input').keypress(function (e) {
    if (e.which == 13)
      $(this).closest('form').submit();

    e.preventDefault();
  });
});
