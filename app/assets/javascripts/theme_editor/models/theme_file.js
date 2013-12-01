App.ThemeFile = DS.Model.extend({
  body: DS.attr("string"),
  filename: DS.attr("string"),
  name: DS.attr("string"),
  description: DS.attr("string"),
  preview_url: DS.attr("string"),
  theme_id: DS.attr("number")
});
