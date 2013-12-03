App.MustacheCommand = DS.Model.extend({
  name: DS.attr("string"),
  description: DS.attr("string"),
  sample: DS.attr("string"),
  type: DS.attr("string"),
  group: DS.attr("string"),
});
