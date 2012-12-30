class AdminForms
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
    $("form input[type='text'][value='']:visible:enabled:first, #main textarea:visible:enabled:first").focus()

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

  custom_button_to: ->
    $('body').on 'click', 'button.js_link_to', ->
      window.location = $(this).data('url')

$ ->
  forms = new AdminForms
  forms.init()

class window.InputLoading
  show: ($input) ->
    $input_parent = $input.parent()
    $input_parent.append $("#input_loading")
    $input_parent.css position: 'relative'

    width     = $input.width()
    height    = $input.height()
    inputTop  = $input.position().top
    inputLeft = $input.position().left

    # spinner gif dimensions: 32x32.
    spinnerLeft = inputLeft + (width - 40) + "px"
    spinnerTop  = inputTop + (height / 2) + "px"

    input_loading_div = $("#input_loading")
    input_loading_div.css
      top:  spinnerTop
      left: spinnerLeft

    input_loading_div.fadeIn()

  hide: ($input) ->
    $input.parent()
      .find("#input_loading")
      .fadeOut(300)
