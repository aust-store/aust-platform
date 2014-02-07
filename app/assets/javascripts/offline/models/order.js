App.Order = DS.Model.extend({
  total:       DS.attr('number'),
  createdAt:   DS.attr('string'),
  environment: DS.attr('string'),
  paymentType: DS.attr('string'),

  cart:        DS.belongsTo('cart'),
  orderItems:  DS.hasMany('orderItem'),
  customer:    DS.belongsTo('customer'),

  translatePaymentType: function() {
    var i18n = {
      "cash":         "À vista",
      "installments": "A prazo",
      "debit":        "Débito",
      "credit_card":  "Cartão de crédito",
    }

    return i18n[this.get('paymentType')];
  }.property()
});
