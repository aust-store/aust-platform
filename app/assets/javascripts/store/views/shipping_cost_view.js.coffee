Emerald.shippingCostView = Emerald.ActionView.extend(
  zipcodeCalculation: (e, fields) ->
    value = e.target.value
    if @isValidZipcode()
      Emerald.shippingCostController.calculate(fields)

  shippingData: ->
    data =
      zipcode: @zipcode
      type: @type

  isValidZipcode: =>
    cartView = $("[data-view='cartView']")
    validZipcode = $('[name="zipcode"]', cartView).val().replace(/[^0-9]/g, '').length == 8
    validServiceType = typeof $(".service_selection [name='type']:checked", cartView).val() != 'undefined'
    validZipcode && validServiceType
)
