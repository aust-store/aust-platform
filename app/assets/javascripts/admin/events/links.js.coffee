$ ->
  $('a.js_another_window').click ->
    window.open($(this).attr('href'))
    return false
