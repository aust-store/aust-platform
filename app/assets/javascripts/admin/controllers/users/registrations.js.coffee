class RegistrationsController
  init: ->
    @init_handle_bind()
    @fill_address_with_handle()

  init_handle_bind: ->
    $("input#handle").on "keyup", (e) =>
      @sanitize_handle()
      @fill_address_with_handle()

  fill_address_with_handle: ->
    $(".store_address .handle").html $("input#handle").val()

  sanitize_handle: ->
    handle = $("input#handle").val()
    handle = handle.replace(/[^a-zA-Z0-9-_]/g, '')
    $("input#handle").val(handle)

$ ->
  controller = new RegistrationsController
  controller.init()

