class SignInForm
  constructor: ->
    @_bindHasNoPasswordClickToDisableInput()
    @_bindHasPasswordClickToEnableInput()
    @_bindPasswordInputClickToEnableHasPassword()

  _bindHasNoPasswordClickToDisableInput: ->
    $('.js_sign_in input#has_no_password').bind 'click focus', ->
      $('.js_sign_in input.password').val('')

  _bindPasswordInputClickToEnableHasPassword: ->
    $('.js_sign_in input.password').bind 'click focus', ->
      $('.js_sign_in input#has_password').attr('checked', true)

  _bindHasPasswordClickToEnableInput: ->
    $('.js_sign_in input#has_password').bind 'click focus', ->
      $('.js_sign_in input.password').focus()

$ ->
  if $('body.store_devise_sessions').length
    new SignInForm
