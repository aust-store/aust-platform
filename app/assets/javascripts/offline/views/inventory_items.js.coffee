App.InventoryItemView = Ember.View.extend
  templateName: 'offline/inventory_item'

App.InventoryItemsSearchTextField = Ember.TextField.extend
  didInsertElement: ->
    Ember.run ->
      $('#inventory_item_search').focus()
