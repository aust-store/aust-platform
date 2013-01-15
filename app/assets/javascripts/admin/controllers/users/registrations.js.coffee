class window.RegistrationsController
  init: ->
    return if $("input#handle").length == 0
    @init_handle_bind()
    setTimeout ( =>
      @fill_store_address_with_handle()
    ), 900

  init_handle_bind: ->
    $("input#handle").on "keyup change", (e) =>
      return false unless @is_valid_input(e)

      @fill_store_address_with_handle()
      true

  is_valid_input: (event) ->
    keypressed = event.which ? event.which || event.keyCode

    letters   = (keypressed >= 65 and keypressed <= 90)
    numbers   = (keypressed >= 48 and keypressed <= 57)
    backspace = (keypressed == 8)
    esc       = (keypressed == 27)
    del       = (keypressed == 46)
    end_home_arrows = (keypressed >= 35 and keypressed <= 40)

    alphanumeric = letters or numbers
    special_keys = backspace or esc or del or end_home_arrows

    return alphanumeric or special_keys

  fill_store_address_with_handle: ->
    $(".store_address .handle").html @sanitized_handle()

  sanitize_input_handle: ->
    $("input#handle").val @sanitized_handle()

  sanitized_handle: ->
    handle = $("input#handle").val()
    handle = handle.replace(/[^a-zA-Z0-9-_]/g, '')
    handle = handle.toLowerCase()

$ ->
  controller = new RegistrationsController
  controller.init()
