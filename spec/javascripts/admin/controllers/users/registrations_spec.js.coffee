#= require spec_helper
#= require admin/controllers/users/registrations

describe 'RegistrationsController', ->
  fixture = ""

  beforeEach ->
    fixture = "<input id='handle' value=''>"
    fixture+= "<div class='store_address'>"
    fixture+= "<span class='handle'></span>"
    fixture+= "</div>"
    $('body').html(fixture)
    @controller = new RegistrationsController
    @controller.init()

  describe '#sanitize_keys', ->
    it 'whatever', ->
      $('#handle').val("my-pet").trigger("change")
      $('.handle').html().should.equal('my-pet')
      $('#handle').val() .should.equal('my-pet')

    it 'whatever', ->
      $('#handle').val("mypet_").trigger("change")
      $('.handle').html().should.equal('mypet_')
      $('#handle').val() .should.equal('mypet_')

    it 'whatever', ->
      $('#handle').val("m.ypet!@#,/;:").trigger("change")
      $('.handle').html().should.equal('mypet')
      $('#handle').val() .should.equal('mypet')

    it 'whatever', ->
      $('#handle').val("Mypet").trigger("change")
      $('.handle').html().should.equal('mypet')
      $('#handle').val() .should.equal('mypet')
