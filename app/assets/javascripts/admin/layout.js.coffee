class Layout
  init: ->
    @faux_column_for_sidebar("#sidebar")
    @faux_column_for_sidebar("#navigation")

  faux_column_for_sidebar: (sidebar_id) ->
    if( $(sidebar_id).height() < $("#main").height() )
      $(sidebar_id).css('min-height', $("#main").height());
    else
      $("#main").css('min-height', $(sidebar_id).height());

$ ->
  layout = new Layout
  layout.init()
