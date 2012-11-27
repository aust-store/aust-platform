Emerald.shippingCostController = Emerald.Controller.extend(
  calculate: (params) ->
    Emerald.zipcodeModel.update(params)
    Emerald.zipcodeModel.save(this)
)
