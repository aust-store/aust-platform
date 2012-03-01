$( ->
  $('input[placeholder],textarea[placeholder]').placeholder()

  $('a[data-ajax]').bind 'click', ->
    $.get(
      $(this).attr("data-ajax"),
      (response) =>
        $($(this).attr("data-complete")).html response
    )
    false

)