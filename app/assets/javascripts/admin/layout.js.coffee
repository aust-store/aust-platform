class Layout
  init: ->
    @faux_column_for_sidebar(".column_pane_half.right", ".column_pane_half.left", true)
    setTimeout ( =>
      @faux_column_for_sidebar("#navigation", "#main", false)
    ), 40


  faux_column_for_sidebar: (sidebar_id, second_element, bothElements) ->
    main    = $(second_element)
    sidebar = $(sidebar_id)
    main_height    = main.outerHeight(true)
    sidebar_height = sidebar.outerHeight(true)

    difference = (main.outerHeight(false) - $(sidebar_id).outerHeight(false))
    if difference < 0
      main.css('minHeight', sidebar_height)
      main.css('height', "+="+(0-difference+10))
      main.css('minHeight', main.css('height'))
      main.css('height', '')
    else if difference > 0 && bothElements
      sidebar.css('minHeight', main_height)
      sidebar.css('height', "-="+(0+difference+10))
      sidebar.css('minHeight', sidebar.css('height'))
      sidebar.css('height', '')

$ ->
  layout = new Layout
  layout.init()
