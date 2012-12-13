#= require store_spec_helper
#= require admin/controllers/users/registrations

describe 'RegistrationsController', ->
  fixture = ""

  beforeEach ->
    @controller = new RegistrationsController
    fixture = "<input id='handle'>"
    fixture+= "<div class='store_address'>"
    fixture+= "<span class='handle'></span>"
    fixture+= "</div>"
   
    $('body').html(fixture)

  describe '#sanitize_keys', ->
    it 'returns false when keys are not valid', ->      
      @controller.sanitize_keys("valor do keyup").should.equal(false)