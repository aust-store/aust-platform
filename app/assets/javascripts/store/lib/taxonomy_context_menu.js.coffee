class TaxonomyContextMenu
  constructor: ->
    @bind_open_link()
    @bind_mouseleave()
    @bind_mouseenter()

  bind_open_link: ->
    that = this
    $("#departments_context_menu_trigger").on "click", (e) ->
      $('#departments_context_menu_trigger').addClass('hover')
      menu = $(e.currentTarget).parent().children('.js_departments_context_menu')
      if menu.is(':visible')
        that.hide(menu)
      else
        menu.show()

      return false

  bind_mouseleave: ->
    $(".js_departments_context_menu").on "mouseleave", (e) =>
      menu = $(e.currentTarget)
      @timer_handle = setTimeout ( =>
        @hide(menu)
      ), 500

  bind_mouseenter: ->
    $(".js_departments_context_menu").on "mouseenter", (e) =>
      clearTimeout(@timer_handle)

  hide: (context_menu) ->
    $('#departments_context_menu_trigger').removeClass('hover')
    context_menu.hide()

  timer_handle: null

$ ->
  new TaxonomyContextMenu
