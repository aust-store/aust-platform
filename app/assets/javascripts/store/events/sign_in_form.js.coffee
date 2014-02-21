class SignInForm
  constructor: ->
    @_bindHasNoPasswordClickToDisableInput()
    @_bindHasPasswordClickToEnableInput()
    @_bindPasswordInputClickToEnableHasPassword()
    @_bindSubmitToSignInOrUp()

  _bindHasNoPasswordClickToDisableInput: ->
    $('.js_sign_in input#has_no_password').bind 'click focus', ->
      $('.js_sign_in input.password').val('')

  _bindPasswordInputClickToEnableHasPassword: ->
    $('.js_sign_in input.password').bind 'click focus', ->
      $('.js_sign_in input#has_password').attr('checked', true)

  _bindHasPasswordClickToEnableInput: ->
    $('.js_sign_in input#has_password').bind 'click focus', ->
      $('.js_sign_in input.password').focus()

  _bindSubmitToSignInOrUp: ->
    $(".js_sign_in #js_new_person").submit ->
      if $("#has_no_password:checked").length
        sign_up = $(this).data('sign-up')
        current_email = $(this).find("#person_email").val()
        window.location = "#{sign_up}?email=#{current_email}"
        return false
      else if $("#has_password:checked").length
        return true

$ ->
  if $('body.store_devise_sessions').length
    new SignInForm
