Ember.Handlebars.helper('image_tag', function(imageName) {
  var imagePath = window.images[imageName];

  return new Handlebars.SafeString('<image src="'+imagePath+'" />');
});
