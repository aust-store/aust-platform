Emerald.zipcodeModel = Emerald.Model.extend(
  attrAccessible: ['id', 'zipcode', 'type']
)

$ ->
  Emerald.zipcodeModel.route = Emerald.Router.zipcodeModel()
