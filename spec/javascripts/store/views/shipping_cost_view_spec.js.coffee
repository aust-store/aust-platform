#= require store_spec_helper
#= require store/views/shipping_cost_view

describe 'ShippingCostView', ->
  fixture = ""

  beforeEach ->
    fixture = "<div data-view='cartView'>"
    fixture+= "<input name='zipcode'>"
    fixture+= "<div class='js_service_selection'>"
    fixture+= "<input type='radio' name='type' value='pac'>"
    fixture+= "<input type='radio' name='type' value='sedex'>"
    fixture+= "</div>"
    fixture+= "</div>"
    $('body').html(fixture)

  describe '#isValidZipcode', ->
    it 'returns false when the zipcode calculation fields are not valid', ->
      Emerald.shippingCostView.isValidZipcode().should.equal(false)

    it 'returns false when the zipcode is absent', ->
      $('[name="type"]', 'body').first().attr("checked", true)
      Emerald.shippingCostView.isValidZipcode().should.equal(false)

    it 'returns false when the service type is absent', ->
      $('[name="zipcode"]', 'body').first().attr("value", "12345678")
      Emerald.shippingCostView.isValidZipcode().should.equal(false)

    describe 'zipcode number validation', ->
      beforeEach ->
        $('[name="type"]', 'body').first().attr("checked", true)

      describe 'invalid zipcode numbers', ->
        afterEach ->
          Emerald.shippingCostView.isValidZipcode().should.equal(false)

        it 'returns false zipcode has 7 chars and a service is selected', ->
          $('[name="zipcode"]', 'body').first().attr("value", "1234567")

        it 'returns false zipcode has 9 chars and a service is selected', ->
          $('[name="zipcode"]', 'body').first().attr("value", "123456789")

        it 'returns false zipcode has 8 letters and a service is selected', ->
          $('[name="zipcode"]', 'body').first().attr("value", "abcdefgh")

      describe 'valid zipcode numbers', ->
        it 'returns true zipcode has 8 chars and a service is selected', ->
          $('[name="zipcode"]', 'body').first().attr("value", "12345678")
          Emerald.shippingCostView.isValidZipcode().should.equal(true)
