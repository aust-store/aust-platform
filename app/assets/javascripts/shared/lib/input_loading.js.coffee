class window.InputLoading
  show: ($input) ->
    $input_parent = $input.parent()
    $input_parent.append $("#input_loading")
    $input_parent.css position: 'relative'

    width     = $input.width()
    height    = $input.height()
    inputTop  = $input.position().top
    inputLeft = $input.position().left

    # spinner gif dimensions: 32x32.
    spinnerLeft = inputLeft + (width - 40) + "px"
    spinnerTop  = inputTop  + (height / 2) + "px"

    input_loading_div = $("#input_loading")
    input_loading_div.css
      top:  spinnerTop
      left: spinnerLeft

    input_loading_div.fadeIn()

  hide: ($input) ->
    $input.parent()
      .find("#input_loading")
      .fadeOut(300)
