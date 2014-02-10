/**
 * Formats a date string into a human date. Format should be one of the
 * following:
 *
 *   - 2013-04-21 00:15:09
 *   - 2013-04-21T00:15:09.000-02:00
 *
 * @param {string,Date} date a date to be formated
 * @returns {Date} e.g 21/04/2013, 00:15
 */
var humanDate = function(date) {
  if (!date) {
    return '';
  }

  if (typeof date === 'string') {
    if (date.match(/T/)) {
      date = new Date(Date.parse(date));
    } else {
      /**
        Matches the format `2013-04-21 00:15:09` as year, month, day, hour and
        minute
       */
      var match  = date.match(/^([0-9]{4})-([0-9]{1,2})-([0-9]{1,2}) ([0-9]{1,2}):([0-9]{1,2})/),
          year   = match[1],
          month  = match[2],
          day    = match[3],
          hour   = match[4],
          minute = match[5];
    }
  }

  if (date.getMonth) {
    var year   = date.getFullYear(),
        month  = date.getMonth()+1,
        day    = date.getDate(),
        hour   = date.getHours(),
        minute = date.getMinutes();
  }

  if (parseInt(hour) < 9) {
    hour = "0"+parseInt(hour);
  }

  if (parseInt(minute) < 9) {
    minute = "0"+parseInt(minute);
  }

  return day + '/' + month + '/' + year + ', ' + hour + ':' + minute;
}

if (typeof Ember != "undefined")
  Ember.Handlebars.registerBoundHelper("humanDate", humanDate);
