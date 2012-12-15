App.Company = DS.Model.extend(
  name: DS.attr('string')
  handle: DS.attr('string')
  total_items: DS.attr('string')
)

App.Company.FIXTURES = [
  "id":1,
  "name":"My Store",
  "handle":"my_store",
  "created_at":"2012-10-30T02:36:30Z",
  "total_items":7
]
