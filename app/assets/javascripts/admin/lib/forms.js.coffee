class Forms
  init: ->
    @init_datepicker()

  init_datepicker: ->
    $("input.date").datepicker()

$ ->
  forms = new Forms
  forms.init()
