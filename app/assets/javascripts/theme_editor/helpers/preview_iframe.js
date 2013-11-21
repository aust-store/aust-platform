Ember.Handlebars.helper('previewIframe', function(item) {
  var previewUrl = Handlebars.Utils.escapeExpression(item.get('preview_url')),
      id = Handlebars.Utils.escapeExpression(item.id);
  return new Handlebars.SafeString('<iframe src="'+previewUrl+'" data-file-id="'+id+'"></iframe>');
});
