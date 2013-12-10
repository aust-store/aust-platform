//= require spec_helper
//= require admin/lib/field_search

describe('Admin.FieldSearch.Results', function() {
  var fixture;

  beforeEach(function() {
    fixture  = '<input id="input1" />';
    fixture += '<input id="input2" />';
    $('body').html(fixture);
  });

  describe('#save', function() {
    it('instantiates both inputs\' results', function() {
      var results = new Admin.FieldSearch.Results;

      $("input").each(function(input) {
        results.addInput($(this));
      });

      results.forInput("input1").save({id: 1, name: "Gravity"});
      results.forInput("input2").save({id: 2, name: "heyo"});

      results.forInput("input1").id.should.equal(1);
      results.forInput("input1").name.should.equal("Gravity");
      results.forInput("input2").id.should.equal(2);
      results.forInput("input2").name.should.equal("heyo");
    });
  });

  describe('#resetInput', function() {
    it('instantiates both inputs\' results', function() {
      var results = new Admin.FieldSearch.Results;

      $("input").each(function(input) {
        results.addInput($(this));
      });

      results.forInput("input1").save({id: 1, name: "Gravity"});
      results.forInput("input2").save({id: 2, name: "heyo"});

      results.forInput("input1").id.should.equal(1);
      results.forInput("input1").name.should.equal("Gravity");
      results.forInput("input2").id.should.equal(2);
      results.forInput("input2").name.should.equal("heyo");

      results.forInput("input1").reset();
      results.forInput("input1").id.should.equal('');
      results.forInput("input1").name.should.equal('');
    });
  });
});
