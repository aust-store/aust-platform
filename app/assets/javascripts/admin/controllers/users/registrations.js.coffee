class RegistrationsController
  init: ->
    @init_handle_bind()
    setTimeout ( =>
      @fill_store_address_with_handle()
    ), 900

  init_handle_bind: ->
    $("input#handle").on "keyup", (e) =>
      @fill_store_address_with_handle()
      @sanitize_handle()
      true

  fill_store_address_with_handle: ->
    $(".store_address .handle").html @sanitized_handle()

  sanitize_handle: ->
    $("input#handle").val @sanitized_handle()

  sanitized_handle: ->
    handle = $("input#handle").val()
    handle = handle.replace(/[^a-zA-Z0-9-_]/g, '')
    handle = handle.toLowerCase()

$ ->
  controller = new RegistrationsController
  controller.init()

