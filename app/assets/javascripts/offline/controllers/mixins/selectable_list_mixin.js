/**
 * App.SelectableListControllerMixin
 *
 * Allows an Array controller to have a selected item. Steps:
 *
 *   - extend the Array
 *   - use the View version of this mixin (SelectableListViewMixin)
 */
App.SelectableListControllerMixin = Ember.Mixin.create({
  resetSelection: function() {
    var selection = this.objectAt(0);
    this.setEach('isSelected', false);
    if (selection)
      selection.set('isSelected', true);
  }.observes("@each.id"),

  actions: {
    changeSelection: function(params) {
      if (!params.hasOwnProperty("direction") || this.get('length') == 0) {
        return false;
      }

      var currentIndex = this.indexOf(this.findBy('isSelected', true) || -1),
          nextIndex = currentIndex + params.direction;

      this.setEach('isSelected', false);
      if (nextIndex == this.get('length')) {
        nextIndex = 0;
      } else if (nextIndex < 0) {
        nextIndex = this.get('length') - 1;
      }

      this.objectAt(nextIndex).set('isSelected', true);
    }
  }
});
