/*
 *= require offline/handlebars
 *= require offline/helpers/human_date
 */
describe('Offline app - humanDate()', function() {
  describe('standard ISO format', function() {
    it('returns the date with hours and minutes', function(){
      humanDate('2013-4-3 0:15:09').should.equal("3/4/2013, 0:15");
    });

    it('returns the date with hours and minutes with leading zeros', function(){
      humanDate('2013-04-03 00:15:09').should.equal("03/04/2013, 00:15");
    });
  });
});
