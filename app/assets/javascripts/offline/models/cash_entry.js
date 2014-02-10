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

App.cashEntryTypes = [{
  id: "addition", name: "Adição - dinheiro entrou no caixa"
}, {
  id: "subtraction", name: "Subtração - dinheiro saiu do caixa"
//}, {
//  id: "missing", name: "Faltando - quantia que está faltando do caixa"
//}, {
//  id: "surplus", name: "Subtração - dinheiro saiu do caixa"
}];
