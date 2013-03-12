/**
  isoDate format is like 2013-03-03 00:15:09
 */
var humanDate = function(isoDate) {
  var match  = isoDate.match(/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2}) ([0-9]{1,2}):([0-9]{1,2})/),
      year   = match[1],
      month  = match[2],
      day    = match[3],
      hour   = match[4],
      minute = match[5];

  return day + '/' + month + '/' + year + ', ' + hour + ':' + minute;
}

if (typeof Ember != "undefined")
  Ember.Handlebars.registerBoundHelper("humanDate", humanDate);
