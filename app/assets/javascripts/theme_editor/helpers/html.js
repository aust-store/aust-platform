Ember.Handlebars.helper('nl2br', function(string) {
  string = string.replace(/\n/g, "<br />");
  return new Handlebars.SafeString(string);
});
