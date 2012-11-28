# Deals with the search page for adding items
class InventoryItemsSearch

  init: ->
    @search_existent_item_event()
    @show_add_item_button()
    @show_item_button_time = 1000
    @hide_button_for_adding_items()
    @bind_load_new_form_after_submit()
    @bind_add_item_button_to_form()

  bind_add_item_button_to_form: ->
    $("#add_new_item_button .button a").on 'click', ->
      $("form#inventory_item_search").submit()
      false

  bind_load_new_form_after_submit: ->
    $("#inventory_item_search").on 'submit', ->
      loading.show $(".main_container")
      $.get(
        $(this).attr("data-ajax"),
        { new_item_name: $("input.search").val() },
        (response) =>
          window.History.pushState({refresh: false}, "Novo item", $("#inventory_item_search").data("ajax"))
          $($(this).attr("data-complete")).html response
          $("#main input[type='text']:first").focus()
      )
      false

    # When the page opens, the user shouldn't be able to enter a new item if he
    # hasn't typed anything for its name.
  hide_button_for_adding_items: ->
    $("#add_new_item_button").hide()

  # Depending on the search results, the button for creating a new inventory
  # item shows up or not
  can_show_add_item_button: ->
    return if $(".search_existent_item").length == 0

    item_div = $(".search_existent_item")
    search_query_length = item_div.find("input.search").val().length
    search_results_length = item_div.find(".result_line").length
    empty_search_query = search_query_length == 0

    show_button = false
    return false if search_query_length < 4
    if search_query_length < 6
      @show_item_button_time = 3000
      show_button = true
    else
      @show_item_button_time = 1000
      show_button = true

    if search_results_length < 2
      @show_item_button_time = 2000
      show_button = true

    else if search_results_length < 4
      @show_item_button_time = 2000
      show_button = true

    else if search_results_length > 5
      @show_item_button_time = 3000
      show_button = true

    if search_results_length < 2 and search_query_length > 4
      @show_item_button_time = 500
      show_button = true

    show_button

  show_proper_creation_explanation_text: ->
    item_div = $(".search_existent_item")
    button_div = $(".add_new_item_button")
    search_results_length = item_div.find(".result_line").length
    button_div.find(".explanation").hide()

    if search_results_length == 0
      button_div.find(".explanation.without_search_results").show()
    else
      button_div.find(".explanation.with_search_results").show()

  show_add_item_button: ->
    clearTimeout @add_item_button_timer

    if @can_show_add_item_button()
      @add_item_button_timer = setTimeout ( =>
        if @can_show_add_item_button()
          @show_proper_creation_explanation_text()
          $(".add_new_item_button").fadeIn(400)

      ), @show_item_button_time
    else
      $(".add_new_item_button").fadeOut(80)

  valid_search_query: (query_element) ->
    return false if query_element.val().length < 2
    true

  # Starts searching for items
  search_existent_item_event: ->
    $(".search_existent_item input.search").bind 'keyup', (event) =>
      @define_loading_visibility(true)
      clearTimeout @search_keydown_delay_timer
      query_el = $(event.target)
      @show_add_item_button()
      if @valid_search_query(query_el)

        # The search starts 1 second after the users typed something
        @search_keydown_delay_timer = setTimeout ( =>
          @search_existent_item_post(query_el)
        ), 1200
      else
        @define_loading_visibility(false)

  define_loading_visibility: (status) ->
    if status == true
      $('#loading').fadeIn(300)
    if status == false
      $('#loading').hide()

  search_existent_item_post: (element) ->
    string = element.val()
    path = element.data("path")
    $.post(
      path,
      { "name": string },
      (response) =>
        @define_loading_visibility(false)
        $(".search_existent_item .search_results").html(response)
        @bind_search_results_to_new_form()
        @show_add_item_button()
    )

  bind_search_results_to_new_form: ->
    $(".search_existent_item .search_results ul li a[data-async='true']").bind "click", (event) ->
      $.get(
        $(event.target).attr("href"),
        (response) ->
          $("#main").html response
      )
      false

$( ->
  if $(".search_existent_item").length > 0
    search = new InventoryItemsSearch
    search.init()
)
