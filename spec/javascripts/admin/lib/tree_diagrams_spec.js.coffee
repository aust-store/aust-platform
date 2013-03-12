#= require spec_helper
#= require admin/lib/tree_diagrams

describe 'TreeDiagrams', ->
  fixture = ""

  beforeEach ->
    fixture = JST['templates/admin/lib/tree_diagrams']()
    $('body').html(fixture)
    new TreeDiagrams

  describe 'editing a node', ->
    it 'replaces the node with a input when the user clicks edit', ->
      node = $('[data-node-id="24"]')

      event = jQuery.Event('click')
      node.find('.box').trigger(event)

      box = node.find('.box')
      box.find('input').hasClass('js_edit_node_input').should.equal(true)
      box.find('input').val().should.equal('Fluminense')

  describe 'creating a node', ->
    context 'as a child', ->
      it 'shows an input when the mouse enters the node', ->
        node = $('[data-node-id="24"]')
        $('.box', node).trigger('mouseenter')

        candidate = node.find('.candidate')
        candidate.hasClass('node').should.equal(true)
        candidate.hasClass('js_candidate').should.equal(true)

        candidate.find('.box').length.should.equal(1)
        candidate.find('a.js_add_node').length.should.equal(1)

    context 'as a sibling', ->
      it 'shows an input when the mouse enters the node', ->
        node = $('[data-node-id="24"]')

        # mouse over
        $('.box', node).trigger('mouseenter')
        group = node.closest('.child')

        # shows options
        candidate = group.children('.candidate')
        candidate.length.should.equal(1)
        candidate.hasClass('node').should.equal(true)
        candidate.hasClass('js_candidate').should.equal(true)
        candidate.find('.box').length.should.equal(1)
        candidate.find('a.js_add_node').length.should.equal(1)

        # click to add a node
        candidate.find('a.js_add_node').trigger('click')

        # types in the input and press enter
        group.find('.candidate_input .box_input input.js_new_node_input').val('Car')

        event = jQuery.Event('change')
        event.keyCode = 13
        group.find('input.js_new_node_input').trigger(event)

        # the node is created
        group.children('.node.js_node:last').find('.box').html().should.equal('Car')
