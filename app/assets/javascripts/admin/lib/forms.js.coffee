class Forms
  init: ->
    @init_datepicker()

  init_datepicker: ->
    $("input.date").datepicker({
      dateFormat: "dd/mm/yy"
    })

$ ->
  forms = new Forms
  forms.init()
