App.Customer = DS.Model.extend({
  firstName: DS.attr('string'),
  lastName:  DS.attr('string'),
  email:     DS.attr('string'),
  socialSecurityNumber: DS.attr('string'),
  order:     DS.hasMany(),

  fullName: function() {
    return this.get('firstName') + " " + this.get('lastName');
  }.property("firstName", "lastName"),

  isValid: function() {
    var hasFirstName    = !!this.get("firstName"),
        hasLastName     = !!this.get("lastName"),
        hasSocialNumber = !!this.get("socialSecurityNumber");

    return hasFirstName && hasLastName && hasSocialNumber;
  }.property("firstName", "lastName", "socialSecurityNumber")
});
