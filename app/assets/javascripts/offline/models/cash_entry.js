App.CashEntry = DS.Model.extend({
  amount:          DS.attr('number'),
  description:     DS.attr('string'),
  entryType:       DS.attr('string'),
  previousBalance: DS.attr('number'),
  createdAt:       DS.attr('date'),

  isValid: function() {
    var hasAmount = this.get('amount'),
        hasDescription = this.get('description');

    return hasAmount && hasDescription;
  }
});
