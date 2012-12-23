class Forms
  constructor: ->
    $("form input[value='']:visible:enabled:first").focus()

    @addLockImageToPasswordInputs()

  addLockImageToPasswordInputs: ->
    $("form .input.password .input_wrapper").each (index, element) ->
      $(element).append($('.html_template .secure_lock_image_template').html())

$ ->
  new Forms
