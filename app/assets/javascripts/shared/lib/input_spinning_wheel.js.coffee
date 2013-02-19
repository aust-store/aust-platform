class window.InputSpinningWheel
  show: ($input) ->
    $input_parent = $input.parent()
    $input_parent.append $("#spinning_wheel")
    $input_parent.css position: 'relative'

    width     = $input.width()
    inputTop  = $input.position().top
    inputLeft = $input.position().left

    # spinner gif dimensions: 32x32.
    spinnerLeft = inputLeft + width - 32 + "px"
    spinnerTop  = inputTop  + "px"

    input_loading_div = $("#spinning_wheel")
    input_loading_div.css
      top:  spinnerTop
      left: spinnerLeft

    input_loading_div.fadeIn()

  hide: ($input) ->
    $input.parent()
      .find("#spinning_wheel")
      .fadeOut(300)