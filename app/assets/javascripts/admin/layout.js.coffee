class Layout
  init: ->
    #@faux_column_for_sidebar("#sidebar")
    @faux_column_for_sidebar("#navigation")
    setTimeout ( =>
      @faux_column_for_sidebar("#navigation")
    ), 40


  faux_column_for_sidebar: (sidebar_id) ->
    sidebar_height = $(sidebar_id).outerHeight(true)
    main = $("#main")
    difference = (main.outerHeight(false) - $(sidebar_id).outerHeight(false))
    main.css('minHeight', sidebar_height)
    if difference < 0
      main.css('height', "+="+(0-difference+10))
      main.css('minHeight', main.css('height'))
      main.css('height', '')

$ ->
  layout = new Layout
  layout.init()
