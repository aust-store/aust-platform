class Forms
  init: ->
    @init_datepicker()
    @setup_image_upload()

  init_datepicker: ->
    $("input.date").datepicker({
      dateFormat: "dd/mm/yy"
    })

  setup_image_upload: ->
    $('.form-upload').bind 'ajax:complete', (evt, xhr, status) ->
       $('.images').html(xhr.responseText)
       $('.form-upload').find('input[type="file"]').val("")

$ ->
  forms = new Forms
  forms.init()
