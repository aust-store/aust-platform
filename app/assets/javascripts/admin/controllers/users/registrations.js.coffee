class RegistrationsController
  init: ->
    @init_handle_bind()
    @fill_address_with_handle()
    @sanitize_handle()

  init_handle_bind: ->
    $("input#handle").on "keyup", (e) =>
      @fill_address_with_handle()
      @sanitize_store_url()
      true

  fill_address_with_handle: ->
    $(".store_address .handle").html $("input#handle").val()
   
  sanitize_fields: ->
    handle = $("input#handle").val()
    handle = handle.replace(/[^a-zA-Z0-9-_]/g, '')
    handle = handle.toLowerCase()

  sanitize_handle: ->
    $("input#name").val(@sanitize_fields)

  sanitize_store_url: ->
    $(".store_address .handle").html @sanitize_fields

$ ->
  controller = new RegistrationsController
  controller.init()

