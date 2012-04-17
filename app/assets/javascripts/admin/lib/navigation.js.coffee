class Navigation
  init: ->
    @bind_events()

  bind_events: ->
    $("a.js-back").on "click", ->
      history.back()

$ ->
  navigation = new Navigation
  navigation.init()
