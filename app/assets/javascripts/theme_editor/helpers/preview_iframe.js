Ember.Handlebars.helper('previewIframe', function() {
  var previewUrl = Handlebars.Utils.escapeExpression(window.previewUrl);
  return new Handlebars.SafeString('<iframe src="'+previewUrl+'" id="preview_element"></iframe>');
});
