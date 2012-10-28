class Layout
  init: ->
    #@faux_column_for_sidebar("#sidebar")
    @faux_column_for_sidebar("#navigation")
    setTimeout ( =>
      @faux_column_for_sidebar("#navigation")
    ), 40


  faux_column_for_sidebar: (sidebar_id) ->
    #console.log $(sidebar_id).innerHeight()
    #console.log $(sidebar_id).outerHeight(false)
    #console.log $("#main").outerHeight(false)
    difference = ($("#main").outerHeight(false) - $(sidebar_id).outerHeight(false))
    #difference = difference.replace("-", "-=").replace("+", "+=")
    #console.log difference
    if difference < 0
      $("#main").css('height', "+="+(0-difference))

$ ->
  layout = new Layout
  layout.init()
