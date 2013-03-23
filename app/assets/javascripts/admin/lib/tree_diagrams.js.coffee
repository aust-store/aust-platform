class window.TreeDiagrams
  constructor: ->
    @_bind_new_node_hover()
    @_bind_new_node_form()
    @_bind_new_node_submit()
    @_bind_edit_node_form()
    @_bind_edit_node_submit()
    @refresh_dynamic_attributes()

    if @has_no_nodes()
      @tree_dom_element().find('.node .box').trigger('mouseenter')

  has_no_nodes: ->
    $('.greatfather_node').parent().children('.node, .child').length == 1

  _bind_new_node_hover: ->
    _that = _this

    @tree_dom_element().delegate '.js_node > .box, .hoverable_end', 'mouseenter', (e) =>
      node = $(e.target)
      @refresh_dynamic_attributes()

      return false if node.hasClass('box_input') or node.hasClass('candidate')
      return false if node.parents('.box').length
      node = node.closest('.js_node') if node.hasClass('box')

      _that.show_node_hover_options(node)

  show_node_hover_options: (node) ->
    candidate = $('.js_tree_body').find('.candidate')

    if candidate.parent('.child').children().length == 1
      candidate.parent('.child').remove()
    else
      candidate.remove()

    @refresh_dynamic_attributes()

    is_first_node = node.hasClass('greatfather_node') && node.parent().children('.node, .child').length == 1

    if is_first_node
      node.after('<div class="child">'+@node_hover_template()+'</div>')
    else if node.hasClass('hoverable_end') or is_first_node
      node.before('<div class="child">'+@node_hover_template()+'</div>')
    else
      if not node.find('.candidate_input').length
        node.append(@node_hover_template)

      if not node.siblings('.candidate_input').length
        if node.is(':last-child') and not node.parent('.child').hasClass('js_last_greatfather_node') and not node.parent('.child').parent('.greatfather').length
          node.after(@node_hover_template)

    @refresh_dynamic_attributes()

  _bind_new_node_form: ->
    _that = _this
    @tree_dom_element().on 'click', '.node.js_candidate a.js_add_node', (e) =>
      _this = $(e.target)
      _that.add_new_node_form $(_this).parent('.js_candidate:first')
      $('.js_tree_body').find('.candidate').remove()

  _bind_new_node_submit: ->
    @tree_dom_element().on 'keyup change', 'input.js_new_node_input', (e) =>

      # esc
      if e.keyCode == 27
        $(e.target).closest('.node').remove()
        return false

      @save_node($(e.target)) if e.keyCode == 13

  _bind_edit_node_form: ->
    _that = _this
    @tree_dom_element().on 'click', '.node.js_node[data-node-id] > .box:not([data-original-content])', (e) =>
      _this = $(e.currentTarget)

      node_content = _this.html()
      _this.attr('data-original-content', node_content)
      _this.html('<input type="text" class="js_edit_node_input" />')
      _this.find('input').val(node_content)
      _this.find('input').focus()

  _bind_edit_node_submit: ->
    @tree_dom_element().on 'keyup change', 'input.js_edit_node_input', (e) =>
      input = $(e.currentTarget)
      # esc
      if e.keyCode == 27 or (e.keyCode == 13 and input.val() == "")
        box = input.closest('.box')
        box.html(box.data('original-content'))
        box.attr('data-original-content', null)
        return false

      @update_node(input) if e.keyCode == 13

  add_new_node_form: (current_candidate_node) =>
    $(current_candidate_node).parent().append(@new_node_input)
    $(current_candidate_node).parent().find('input').focus()
    $(current_candidate_node).remove()
    @refresh_dynamic_attributes()

  update_node: (input) ->
    return if input.val() == ""

    node_id = input.closest('.js_node').data('node-id')
    box = input.closest('.box')
    box.html(input.val())
    box.attr('data-original-content', null)

    $.ajax(
      url:  $('.js_tree_body').data('create-url') + "/" + node_id
      data: { _method: "PUT", name: input.val() }
      type: "POST"
      dataType: "json"
    )

  save_node: (input) ->
    random_temporary_id = Math.floor(Math.random()*11) + 100
    node = input.closest('.js_node')
    node = input.closest('.child').prev('.js_node') if node.length == 0
    node = input.closest('.child').siblings('.js_node:first') if node.length == 0

    is_inside_box = node.find(input).length
    is_greatfather_node = node.hasClass('greatfather_node')
    has_subnodes = node.next('.child').length # has many subnodes
    is_last_greatfather_node = input.closest('.child').hasClass('js_last_greatfather_node')

    cloned_template = $(@node_template()).clone()
    cloned_template.find('.box').html input.val()
    cloned_template.find('.js_node').attr('data-temporary-node-id', random_temporary_id)

    if is_last_greatfather_node
      if node.find(input).length
        node.closest('.child').addClass('has_children')
        node.after('<div class="child">'+cloned_template.html()+'</div>')
      else
        $('.hoverable_end').before('<div class="child">'+cloned_template.html()+'</div>')

    else if is_greatfather_node
      node.after('<div class="child">'+cloned_template.html()+'</div>')

    else if has_subnodes
      if node.hasClass('.child')
        node.next('.child').prepend(cloned_template.html())
      else
        node.next('.child').append(cloned_template.html())

    else if is_inside_box
      if node.hasClass('.child')
        node.addClass('has_children')
        node.append(cloned_template.html())
      else
        node.closest('.child').addClass('has_children')
        node.after('<div class="child">'+cloned_template.html()+'</div>')

    else
      father_node = input.closest('.child')
      father_node.append cloned_template.html()

    @persist_node(input, random_temporary_id)
    @remove_input input
    @refresh_dynamic_attributes()

  remove_input: (input) =>
    parent = input.closest('.candidate_input').parent('.child')
    input.closest('.candidate_input').remove()
    parent.remove() if parent.children().length == 0

  refresh_dynamic_attributes: ->
    $('.js_last_greatfather_node').removeClass('js_last_greatfather_node')
    child = $('.greatfather > .child').last()
    child.addClass('js_last_greatfather_node')

    $('.child .js_has_one_node').removeClass('js_has_one_node')
    $('.greatfather > .child .child').each (index) ->
      el = $(this)
      if el.children('.node').length == 1
        el.addClass('js_has_one_node')

    $('.has_children').removeClass('has_children')
    $('.child').each (index) ->
      el = $(this)
      if el.children('.child').length
        el.addClass('has_children')

  persist_node: (input, new_node_temporary_id) ->
    father_js_node      = input.closest('.js_node')
    father_prev_js_node = input.closest('.child').prev('.js_node')
    father_child        = input.closest('.child').closest('.has_children')

    if father_js_node.length
      parent_id = father_js_node.data('node-id')

    else if father_prev_js_node.length
      parent_id = father_prev_js_node.data('node-id')

    else if father_child.length
      father_js_node = father_child.children('.js_node:first')
      parent_id = father_js_node.data('node-id')

    else
      parent_id = ''

    $.post(
      $('.js_tree_body').data('create-url')
      { parent_id: parent_id, name: input.val() }
      (data) ->
        new_node = $("[data-temporary-node-id='#{new_node_temporary_id}']")
        new_node.attr('data-node-id', data.taxonomy.id)
        new_node.attr('data-temporary-node-id', null)
    )

  father_node: (current_node) ->
    father = current_node.closest('.js_node')
    unless father.length
      father = current_node.closest('.child.has_children').find('.js_node:first')
    father

  tree_templates:      -> $('.js_tree_diagrams .html_template')
  tree_dom_element:    -> $('.js_tree_diagrams .js_tree_body')
  new_node_input:      => $('.candidate_input_template', @tree_templates()).html()
  node_template:       => $('.node_template', @tree_templates())
  node_hover_template: => $('.node_hover_template', @tree_templates()).html()

$ ->
  if $('.js_tree_diagrams').length
    new TreeDiagrams
