/*
 *= require offline/handlebars
 *= require offline/helpers/money
 */
describe('Offline app - money() helper', function() {
  it('converts a float into a proper R$ value', function(){
    money(12.13)     .should.equal("12,13");
    money("12.13")   .should.equal("12,13");
    money(1212.13)   .should.equal("1.212,13");
    money("1212.13") .should.equal("1.212,13");
    money("1,212.13").should.equal("1.212,13");
    money("1a212.13").should.equal("1.212,13");
    money("212,13")  .should.equal("212,13");
    money("212,1")   .should.equal("212,10");
    money("212.1")   .should.equal("212,10");
  });

  it('returns 0,00 when 0 is passed as argument', function() {
    money(0).should.equal("0,00");
  });

  it('returns 0,00 when 0 is passed as argument', function() {
    money(undefined).should.equal("0,00");
  });
});
