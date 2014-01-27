/**
 * App.SelectableListViewMixin
 *
 * This mixing gets the up and down arrows in the view and sends it to the
 * controller. Steps:
 *
 *   - define your view input
 *   - extend this mixin
 *   - make sure your view's controller is the one with
 *     (App.SelectableListControllerMixin)
 *
 * If you define keyDown in your view, make sure to call the following there:
 *
 *   this._super(event);
 *
 */
App.SelectableListViewMixin = Ember.Mixin.create({
  keyDown: function(e) {
    var offset;

    // up arrow
    // down arrow
    if (e.keyCode === 38) { offset = -1; }
    else if (e.keyCode === 40) { offset = 1; }

    if (offset) {
      e.stopPropagation();
      this.get('controller').send('changeSelection', { direction: offset });
      return false;
    }

    return true;
  }
});
