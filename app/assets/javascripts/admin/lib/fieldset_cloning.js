var FieldsetCloning = {
  observe: function() {
    FieldsetCloning.Events.setup();
  }
}

FieldsetCloning.Events = {
  setup: function() {
    $('.js_clone_fieldset').click(function(e) {
      var cloning = new FieldsetCloning.Cloning($(this));
      cloning.clone();
      return false;
    });
  }
}

FieldsetCloning.Cloning = function(cloneButton) {

  this.fieldsetSelector = "fieldset." + cloneButton.data('fieldset-to-clone');

  /**
    Public methods
   */

  /**
    @public

    The main method to be used to clone a fieldset.

    @method clone
   */
  this.clone = function() {
    /**
      Picks the last fieldset, the one which is going to be cloned.
     */
    var fieldsetToClone = getFieldsetToClone.call(this);

    /**
      Changes all field keys and values from the cloned element before adding
      it to the page
     */
    var newFieldset = setNewValuesForNewFieldset.call(this, fieldsetToClone);

    /**
      Clones the last fieldset and insert it after the last fieldset.
     */
    cloneElementAfterLast.call(this, fieldsetToClone, newFieldset);
  }

  /**
    @public

    Receives a input with a name such as `field[0][name]` and returns a new
    input with name such as `field[1][name]`.

    Also replaces the id `field_0_name` to `field_1_name`.

    @method inputNewElement
    @param input
    @return input {JQuery object}
   */
  this.inputNewElement = function(input) {
    var input       = $(input),
        currentName = input.attr('name'),
        currentId   = input.attr('id');

    input.attr('name', newNameBasedOnOldElement(currentName));
    if (currentId) {
      input.attr('id', newIdBasedOnOldElement(currentId));
    }
    input.val("");
    return input;
  }

  /**
    @public

    Receives a label with a for attribute such as `field_0_name` and returns
    a new input with name such as `field_1_name`.

    @method labelNewElement
    @param label element
    @return label {JQuery object}
   */
  this.labelNewElement = function(label) {
    var label      = $(label),
        currentFor = label.attr('for');

    label.attr('for', newIdBasedOnOldElement(currentFor));
    return label;
  }

  /**
    @public

    Given a parameter `Number 4`, returns the string `Number 5`.

    @method incrementalNumber
    @param currentIncrement {String}
    @return string {String}
   */
  this.incrementalNumber = function(currentIncrement) {
    return String(currentIncrement).replace(/([0-9])/g, function($1) {
      return parseInt($1) + 1;
    });
  }

  /**
    Private methods
   */
  /**
    @private

    description

    @method getFieldsetToClone
    @return The jQuery object of the last fieldset, the one meant to be cloned.
   */
  var getFieldsetToClone = function() {
    return $(this.fieldsetSelector + ':last');
  }

  var setNewValuesForNewFieldset = function(lastFieldsetElement) {
    var newFieldset = $(lastFieldsetElement).clone();

    var that = this;
    /**
      Replaces all inputs with the new ones, containing new field names.
     */
    $('input', newFieldset).each(function(index, input) {
      $(input).replaceWith(function() { return that.inputNewElement(this).clone(); });
    });

    /**
      Replaces all labels with the new ones, containing new ids.
     */
    $('label', newFieldset).each(function(index, label) {
      $(label).replaceWith(function() { return that.labelNewElement(this).clone(); });
    });

    /**
      Replaces any incremental number available in the HTML.
     */
    $('.js_increment', newFieldset).each(function(index, increment) {
      increment = $(increment);
      $(this).html( that.incrementalNumber(increment.html()) );
    });

    return newFieldset;
  }
  /**
    @private

    Clones the element passed in, and then insert it right after this element
    that was just passed in.

    @method cloneElementAfterLast
    @param lastFieldsetElement {String}
   */
  var cloneElementAfterLast = function(lastFieldsetElement, newFieldset) {
    $('body').find(lastFieldsetElement).after(newFieldset);
  }

  /**
    @private
   */
  var newNameBasedOnOldElement = function(currentName) {
    var currentNumber = currentName.match(/\[([0-9])\]\[/g),
        newName = currentName,
        newNumber;

    if (currentNumber) {
      currentNumber = currentNumber.slice(-1)[0].match(/[0-9]/);
      newNumber     = parseInt(currentNumber) + 1;
      newName       = currentName.replace("["+currentNumber+"][", "["+newNumber+"][");
    }

    return newName;
  }

  var newIdBasedOnOldElement = function(currentId) {
    var currentNumber = currentId.match(/[_|\[]([0-9])[_|\]]/g),
        newName = currentId,
        newNumber;

    if (currentNumber) {
      currentNumber = currentNumber.slice(-1)[0].match(/[0-9]/);
      newNumber     = parseInt(currentNumber) + 1;
      newName       = currentId.replace("_"+currentNumber+"_", "_"+newNumber+"_");
    } else if (currentNumber = currentId.match(/[^_]([0-9]{0,})$/)) {
      newNumber     = parseInt(currentNumber[0]) + 1;
      newName       = currentId.replace(new RegExp(currentNumber[0]+"$"),
                                        newNumber);
    }
    return newName;
  }

  return this;
}

$(document).ready(function() {
  FieldsetCloning.observe();
});
