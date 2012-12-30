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
    $("#main input[type='text']:first, #main textarea:first").focus()

  setup_image_upload: ->
    $('.form-upload.image').bind 'ajax:complete', (evt, xhr, status) ->
       $('.images').html(xhr.responseText)
       $('.form-upload').find('input[type="file"]').val("")

  show_loading_on_form_submit: ->
    $("form[data-remote='true']").on "submit", ->
      page_loading = new PageLoading
      page_loading.show($(this).parents(".form_loading_section"))

  hide_loading_on_form_response: ->
    $("form").on "ajax:complete", ->
      page_loading = new PageLoading
      page_loading.hide($(this).parents(".form_loading_section"))

$ ->
  forms = new Forms
  forms.init()