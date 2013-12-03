Ember.Handlebars.helper('nl2br', function(string) {
  string = string.replace(/\n/g, "<br />");
  return new Handlebars.SafeString(string);
});
Ember.Handlebars.helper('nl2p', function(string) {
  string = string.replace(/\n\n/g, "</p><p>");
  return new Handlebars.SafeString("<p>"+string+"</p>");
});
