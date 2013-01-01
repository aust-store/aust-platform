#= require spec_helper
#= require admin/controllers/users/registrations

describe 'RegistrationsController', ->
  fixture = ""
  event = jQuery.Event("change")

  beforeEach ->
    fixture = "<input id='handle' value=''>"
    fixture+= "<div class='store_address'>"
    fixture+= "<span class='handle'></span>"
    fixture+= "</div>"
    $('body').html(fixture)
    @controller = new RegistrationsController
    @controller.init()

  describe '#init_handle_bind', ->
    it 'fills .handle when the input value is valid', ->
      event = jQuery.Event("change")
      event.keyCode = 5 # invalid keyCode
      $('#handle').val("my-pet").trigger(event)
      $('.handle').html().should.equal('')
      $('#handle').val() .should.equal('my-pet')

    it 'doesn\'t fill .handle when the input value is invalid', ->
      event = jQuery.Event("change")
      event.keyCode = 68 # valid keyCode
      $('#handle').val("my-pet").trigger(event)
      $('.handle').html().should.equal('my-pet')
      $('#handle').val() .should.equal('my-pet')

  describe '#is_valid_input', ->
    it 'sanitizes a letter', ->
      for key in [65..90]
        event.keyCode = key
        @controller.is_valid_input(event).should.equal(true)

    it 'sanitizes a number', ->
      for key in [48..57]
        event.keyCode = key
        @controller.is_valid_input(event).should.equal(true)

    it 'sanitizes a backspace', ->
      event.keyCode = 8
      @controller.is_valid_input(event).should.equal(true)

    it 'sanitizes an escape', ->
      event.keyCode = 27
      @controller.is_valid_input(event).should.equal(true)

    it 'sanitizes a delete', ->
      event.keyCode = 46
      @controller.is_valid_input(event).should.equal(true)

    it 'sanitizes an end, home and arrow keys', ->
      for key in [35..40]
        event.keyCode = key
        @controller.is_valid_input(event).should.equal(true)

    it 'sanitizes anything else', ->
      keys = [0, 1, 2, 3, 4, 5, 6 ,7]
      for key in keys
        event.keyCode = key
        @controller.is_valid_input(event).should.equal(false)

  describe '#sanitized_handle', ->
    it 'sanitizes my-pet', ->
      $('#handle').val("my-pet")
      @controller.sanitized_handle().should.equal('my-pet')

    it 'sanitizes mypet_', ->
      $('#handle').val("mypet_")
      @controller.sanitized_handle().should.equal('mypet_')

    it 'sanitizes m.ypet!@#,/;:', ->
      $('#handle').val("m.ypet!@#,/;:")
      @controller.sanitized_handle().should.equal('mypet')

    it 'sanitizes Mypet', ->
      $('#handle').val("Mypet")
      @controller.sanitized_handle().should.equal('mypet')
