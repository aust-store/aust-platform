/**
  isoDate format is like 2013-04-21 00:15:09

  @returns a date like 21/04/2013, 00:15
 */
var humanDate = function(isoDate) {
  if (!isoDate) {
    return '';
  }

  /**
    Matches the format `2013-04-21 00:15:09` as year, month, day, hour and
    minute
   */
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
