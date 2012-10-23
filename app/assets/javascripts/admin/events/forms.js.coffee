class Forms
  init: ->
    @init_datepicker()
    @set_focus_on_first_input()
    @setup_image_upload()
    @show_loading_on_form_submit()
    @hide_loading_on_form_response()

  init_datepicker: ->
    $("input.date").datepicker({
      dateFormat: "dd/mm/yy"
    })

  set_focus_on_first_input: ->
    $("[data-input-focus='true'] input:first").focus()

  setup_image_upload: ->
    $('.form-upload.image').bind 'ajax:complete', (evt, xhr, status) ->
       $('.images').html(xhr.responseText)
       $('.form-upload').find('input[type="file"]').val("")

  show_loading_on_form_submit: ->
    $("form[data-remote='true']").on "submit", ->
      loading.show($(this).parents(".form_loading_section"))

  hide_loading_on_form_response: ->
    $("form").on "ajax:complete", ->
      loading.hide($(this).parents(".form_loading_section"))

$ ->
  forms = new Forms
  forms.init()
