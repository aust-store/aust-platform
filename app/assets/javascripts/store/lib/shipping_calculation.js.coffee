class ShippingCalculation
  init: ->
    @keyup_event()
    @change_event()

  shipping_calculate: ->
    if @is_valid_zipcode()
      zipcode       = $('[name="zipcode"]').val()
      request_url   = $("input#zipcode").data("shipping-path")
      shipping_type = $(".js_service_selection [name='type']:checked").val()
      $.ajax(
        type: "POST"
        url: request_url
        data:
          "zipcode": zipcode
          "type":    shipping_type
        beforeSend: ->
          new InputSpinningWheel().show $("input#zipcode")
        complete: ->
          new InputSpinningWheel().hide $("input#zipcode")
        success: (response) ->
          $(".js_zipcode_cost").html(response.zipcode.cost)
          $(".js_zipcode_days").html(response.zipcode.days)
        error: (response) ->
          $(".js_zipcode_cost").html("")
          $(".js_zipcode_days").html("")
          responseText = jQuery.parseJSON(response.responseText)
          $("div#error").html(responseText.errors[0])
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