//= require spec_helper
//= require admin/lib/fieldset_cloning

describe('FieldsetCloning', function() {
  var fixture;
  var subject;

  beforeEach(function() {
    fixture = JST['templates/admin/lib/fieldset_cloning']()
    $('body').html(fixture)
    var eventTrigger = $('.js_clone_fieldset');
    subject = new FieldsetCloning.Cloning(eventTrigger);
  });

  describe('cloning a node with a regular array (no number specified)', function() {
    it('keeps the former fieldset name', function() {
      $('[name="inventory_item[option][]"]').length.should.equal(1);
      $('#cost_per_unit_0').length.should.equal(1);
      $('#cost_per_unit_1').length.should.equal(0);
      $('#cost_per_unit_2').length.should.equal(0);
      subject.clone();
      $('[name="inventory_item[option][]"]').length.should.equal(2);
      $('#cost_per_unit_0').length.should.equal(1);
      $('#cost_per_unit_1').length.should.equal(1);
      $('#cost_per_unit_2').length.should.equal(0);
      subject.clone();
      $('[name="inventory_item[option][]"]').length.should.equal(3);
      $('#cost_per_unit_0').length.should.equal(1);
      $('#cost_per_unit_1').length.should.equal(1);
      $('#cost_per_unit_2').length.should.equal(1);
    });
  });

  describe('cloning a node', function() {
    var input1, input2, label1, label2;

    beforeEach(function() {
      subject.clone();
    });

    it('keeps the former fieldset intact', function() {
      $('[name="inventory_item[entries_attributes][0][quantity]"]').length.should.equal(1);

      $('[name="inventory_item[entries_attributes][0][cost_per_unit]"]').length.should.equal(1);
    });

    it('clones the fieldset with the correct new field name numbers', function() {

      input1 = $('input[name="inventory_item[entries_attributes][1][quantity]"]');
      input2 = $('input[name="inventory_item[entries_attributes][1][cost_per_unit]"]');
      label1 = $('label[for="inventory_item_entries_attributes_1_quantity"]');
      label2 = $('label[for="inventory_item_entries_attributes_1_cost_per_unit"]');

      input1.length.should.equal(1);
      input2.length.should.equal(1);
      label1.length.should.equal(1);
      label2.length.should.equal(1);

      input1.attr('id').should.equal('inventory_item_entries_attributes_1_quantity')
      input2.attr('id').should.equal('inventory_item_entries_attributes_1_cost_per_unit')
    });

    it('clones the fieldset twice with the correct new field name numbers', function() {
      // clones again
      subject.clone();

      input1 = $('input[name="inventory_item[entries_attributes][2][quantity]"]');
      input2 = $('input[name="inventory_item[entries_attributes][2][cost_per_unit]"]');
      label1 = $('label[for="inventory_item_entries_attributes_2_quantity"]');
      label2 = $('label[for="inventory_item_entries_attributes_2_cost_per_unit"]');

      input1.length.should.equal(1);
      input2.length.should.equal(1);
      label1.length.should.equal(1);
      label2.length.should.equal(1);

      input1.attr('id').should.equal('inventory_item_entries_attributes_2_quantity')
      input2.attr('id').should.equal('inventory_item_entries_attributes_2_cost_per_unit')
    });

    it('increases the incremental numbers present in the HTML', function() {
      $('.js_increment:contains("1")').length.should.equal(1);
      $('.js_increment:contains("2")').length.should.equal(1);
      $('.js_increment:contains("3")').length.should.equal(0);
    });
  });

  describe("#fieldsetSelector", function() {
    it("returns the correct selector to be used", function() {
      subject.fieldsetSelector.should.equal("fieldset.entry");
    });
  });

  describe("#inputNewElement", function() {
    var input;

    beforeEach(function() {
      input = $("<input name='inventory_item[entries_attributes][1][cost_per_unit]' />");
      input.attr('id', 'inventory_item_entries_attributes_1_cost_per_unit');
    });

    it("changes name of the input", function() {
      subject.inputNewElement(input).attr('name')
        .should.equal("inventory_item[entries_attributes][2][cost_per_unit]");
    });

    it("changes the id of the input", function() {
      subject.inputNewElement(input).attr('id')
        .should.equal("inventory_item_entries_attributes_2_cost_per_unit");
    });
  });

  describe("#labelNewElement", function() {
    it("returns the new label element to be inserted as clone", function() {
      var input = $("<label for='inventory_item_entries_attributes_1_cost_per_unit' />");

      subject.labelNewElement(input).attr('for')
        .should.equal("inventory_item_entries_attributes_2_cost_per_unit");
    });
  });

  describe("#incrementalNumber", function() {
    it("increments the passed in number when string is passed in", function() {
      subject.incrementalNumber("1").should.equal("2");
      subject.incrementalNumber("number 1").should.equal("number 2");
    });
  });
});
