Emerald.shippingCostView = Emerald.ActionView.extend({
  zipcodeCalculation: function(e, fields){
    var value = e.target.value;
    if (this.isValidZipcode(value) )
      Emerald.shippingCostController.calculate(fields);
  },

  shippingData: function(){
    var data = {
      zipcode: this.zipcode,
      type: this.type
    }
  },

  isValidZipcode: function(value){
    return value.replace(/[^0-9]/g, '').length == 8;
  }
});
