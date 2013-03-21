$(document).ready(function() {
  $("a#submit_link").click(function() {
    $(this).parents("form").submit();
    return false;
  });
});
