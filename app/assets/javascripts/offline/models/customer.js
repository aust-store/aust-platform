App.Customer = DS.Model.extend({
  firstName: DS.attr('string'),
  lastName:  DS.attr('string'),
  email:     DS.attr('string'),
  socialSecurityNumber: DS.attr('string'),
  order:     DS.hasMany(),


  fullName: function() {
    return this.get('firstName') + " " + this.get('lastName');
  }.property("firstName", "lastName")
});
