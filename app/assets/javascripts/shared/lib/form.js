$(document).ready(function() {
  $("a#submit_link").each(function() {
    $(this).parents("form").find("[type='submit']").hide();
  });

  $("a#submit_link").click(function() {
    $(this).parents("form").submit();
    return false;
  });
});
