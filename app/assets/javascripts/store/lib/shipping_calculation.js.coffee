class ShippingCalculation
  init: ->
    @keyup_event()
    @change_event()

  shipping_calculate: ->
    if @is_valid_zipcode()
      zipcode  = $('[name="zipcode"]').val()
      path     = $("input#zipcode").data("path")
      type     = $(".js_service_selection [name='type']:checked").val()
      $.ajax(
        type: "POST"
        url: path
        data:
          "zipcode": zipcode
          "type":    type
        beforeSend: ->
          input_loading = new InputLoading
          input_loading.show($(".zipcode"))
        complete: ->
          input_loading = new InputLoading
          input_loading.hide($(".zipcode"))
        success: (response) ->
          $('[name="zipcode_cost"]').html(response.zipcode.cost)
          $('[name="zipcode_days"]').html(response.zipcode.days)
          $("div#error").html("")
        error: (response) ->
          $('[name="zipcode_cost"]').html("")
          $('[name="zipcode_days"]').html("")
          $("div#error").html(response.responseText)
      )

  is_valid_zipcode: =>
    valid_zipcode = $('[name="zipcode"]').val().replace(/[^0-9]/g, '').length == 8
    valid_service_type = typeof $(".js_service_selection [name='type']:checked").val() != 'undefined'
    valid_zipcode && valid_service_type

  keyup_event: ->
    $("input#zipcode").bind 'keyup', (event) =>
      @shipping_calculate()

  change_event: ->
    $(".js_service_selection [name='type']").bind 'change', (event) =>
      @shipping_calculate()

$( ->
  shipping_calculate = new ShippingCalculation
  shipping_calculate.init()
)