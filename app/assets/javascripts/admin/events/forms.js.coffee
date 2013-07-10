class Forms
  init: ->
    @init_datepicker()
    @set_focus_on_first_input()
    @setup_image_upload()
    @show_loading_on_form_submit()
    @hide_loading_on_form_response()
    @custom_button_to()

  init_datepicker: ->
    $("input.date").datepicker({
      dateFormat: "dd/mm/yy"
    })

  set_focus_on_first_input: ->
    $("form input[type='text'], #main textarea")
      .filter(':visible:enabled:first')
      .focus()

  setup_image_upload: ->
    $('.form-upload.image').bind 'ajax:complete', (evt, xhr, status) ->
       $('.images').html(xhr.responseText)
       $('.form-upload').find('input[type="file"]').val("")

  show_loading_on_form_submit: ->
    $("form[data-remote='true'], .form-upload").on "submit", ->
      page_loading = new PageLoading
      page_loading.show($(this).parents(".form_loading_section"))

  hide_loading_on_form_response: ->
    $("form").on "ajax:complete", ->
      page_loading = new PageLoading
      page_loading.hide($(this).parents(".form_loading_section"))

  custom_button_to: ->
    $('body').on 'click', 'button.js_link_to', ->
      window.location = $(this).data('url')

$ ->
  forms = new Forms
  forms.init()
