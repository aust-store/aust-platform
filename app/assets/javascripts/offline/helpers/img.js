var img = function(name, options) {
  if (!window.images) {
    return true;
  }

  var tag = '<img',
      attributes = {
        "src": window.images[name],
        "class": options.hash.class,
        "width": options.hash.width,
        "height": options.hash.height
      };

  for (var key in attributes) {
    if (attributes[key] && attributes.hasOwnProperty(key)) {
      tag += ' '+key+'="'+attributes[key]+'"';
    }
  }

  return new Handlebars.SafeString(tag+' />');
}

if (typeof Ember != "undefined")
  Ember.Handlebars.registerBoundHelper("img", img);
