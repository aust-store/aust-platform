var money = function(value) {
  var decimal = ",";

  if (typeof value == "undefined")
    return "0" + decimal + "00";

  var value = String(value),
      result;

  // removes alpha chars
  value = value.replace(/[a-zA-Z]/, "");

  // convert decimal to x
  value = value.replace(/[\.|,]([0-9]{1,2})$/, "x$1");

  // removes all non-numerical chars
  value = value.replace(/[\.|,]/, "");

  value = value.replace(/([0-9]{1})([0-9]{3})(x[0-9]{2})$/, "$1.$2$3");

  // adds trailling zeros, e.g 12x1 => 12x10
  value = value.replace(/(x[0-9]{1})$/, "$10");

  // adds decimal if it doesn't have it, e.g 10 => 10,00
  if (!value.match(/x/))
    value = value + "x00";

  // finalizes by setting the decimal
  value = value.replace(/x/, decimal);
  return value;
}

if (typeof Ember != "undefined")
  Ember.Handlebars.registerBoundHelper("money", money);
