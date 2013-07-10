class window.PageLoading
  show: ($element) ->
    $element.css
      position: "relative"
      display:  "table"
    $element.append $("#loading_timer").html()
    $element.find("#page_loading").fadeIn()
    @show_timeout_text $element

  hide: ->
    $("#global #page_loading").remove()

  show_timeout_text: ($element) ->
    setTimeout (->
      $element.find(".text").hide()
      $element.find(".text.timeout").show()
    ), 15000
