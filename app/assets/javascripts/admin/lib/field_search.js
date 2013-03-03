var Admin = {};

/**
  This was created to support the Inventory Item form search.

  Whenever the user types something in the Category (taxonomy) or Manufacturer
  field, we do a search via Ajax for that term and get a response from the
  server. We then either:

    a) show results for the user to choose
    b) show one existing result and also populate a hidden field with the
       corresponding ID of the searched and matched resource

  In case of more then one result, we give the option for the user to choose.
  Based on that, we execute b.

  This code will work on any input that satisfies the following criteria:

    * has data-search-url containing the URL in which we should search for
      whenever the user types something
    * has data-result-id containing the ID of the input in which it should
      populate with the matching result.

  Example:

    The user searches for Nike. One unique result comes back from the server,
    in JSON format. We then get the corresponding ID and populate another
    input, usually hidden, which will then be sent to the server when the form
    is submitted.
 */
$(document).ready(function(){
  Admin.FieldSearch.init()
});

Admin.FieldSearch = {
  lastResults:    null,
  selectedResult: null,
  keypressTimer:  null,

  init: function() {
    var that = this;

    $('html').click(function() { that.removePopup(); });
    $('.popup_result').click(function(e) { e.stopPropagation(); });

    $('input[data-search-url]').keyup(function(e){

      /**
        Whenever the user types, we wait 600 miling seconds before doing the
        search. If the user types again in that period, we search again.

        That way, we avoid making unnecessary requests to the server.
       */
      clearTimeout(that.keypressTimer);

      that.keypressTimer = setTimeout(function() {
        that.processKeyPress(e)
      }, 600);

      /**
        13 is the key code for Enter.
       */
      if (e.keyCode == 13) {
        that.userPressesEnter(e);
        return false;
      }
    });

    $('input[data-search-url]').keydown(function(e){
      if (e.keyCode == 13)
        return false;

      /**
        9 stands for Tab.
       */
      if (e.keyCode == 9) {
        that.userPressesEnter(e);
        that.removePopup();
      }
    });
  },

  /**
    Whenever the user types something, this is called.
   */
  processKeyPress: function(e) {
    var input = $(e.target);

    if ($('.popup_result a').length) {
      if (e.keyCode == 40 || e.keyCode == 38) {

        this._verticalSelection(e);
        return false;
      }
    }

    this.selectedResult = null;

    this.clearId(input);
    this._searchRequest(input);
  },

  removePopup: function() {
    $('.popup_result').remove();
  },

  clearId: function(input) {
    var idField = this.idField(input.attr('id'));
    idField.val('');
  },

  idField: function(textFieldId) {
    var input = $('#' + textFieldId);

    if (input.data('result-id'))
      return $('#' + input.data('result-id'));
    else
      return $('#' + textFieldId + '_id');
  },

  _searchRequest: function(input) {
    var that = this;

    $.ajax({
      url: input.data('search-url'),
      data: { search: input.val() },
      dataType: "json",
      complete: function(response) {
        response = $.parseJSON(response.responseText);

        for(key in response) {
          that.lastResults = response[key];
          break;
        }

        if (!that.lastResults.length)
          that.removePopup();
        else
          Admin.FieldSearch.ResultsPopup.showResults(input);
      }
    });
  },

  _verticalSelection: function(e) {
    var current     = $('.popup_result a.current'),
        firstResult = $('.popup_result a:first'),
        lastResult  = $('.popup_result a:last'),
        next,
        previous;

    /**
      Arrow down
     */
    if (e.keyCode == 40) {
      if (!current.length) {
        next = firstResult;
      } else {
        next = current.parent('li').next('li').find('a');
      }

      if (!next.length)
        next = firstResult;

      this.selectedResult = next.data('id');
    } else if (e.keyCode == 38) {
      if (!current.length) {
        previous = lastResult;
      } else {
        previous = current.parent('li').prev('li').find('a');
      }

      if (!previous.length)
        previous = lastResult;

      this.selectedResult = previous.data('id');
    }

    Admin.FieldSearch.ResultsPopup.showResults($(e.target));
  },

  userPressesEnter: function(e) {
    if (this.selectedResult) {
      var selectedName = $('.popup_result a[data-id="'+this.selectedResult+'"]').html();

      if (selectedName)
        $(e.target).val(selectedName);

      this.removePopup();
    }
  }
}

Admin.FieldSearch.ResultsPopup = {
  showResults: function(input) {
    var popupResult = this._createPopup();
    this._prepareInput(input);
    this._populateResultPopup(input, popupResult);
    this._showResultPopup(input, popupResult);
  },

  _createPopup: function() {
    var popupResult = document.createElement('div');
    popupResult.setAttribute('class', 'popup_result field_search_results');
    return popupResult;
  },

  _prepareInput: function(input) {
    input.parent().css('position', 'relative');
  },

  _populateResultPopup: function(input, resultElement) {
    Admin.FieldSearch.ResultsPopupDrawing.drawResults(input, resultElement);
  },

  _showResultPopup: function(input, resultElement) {
    Admin.FieldSearch.removePopup();
    input.parent().append(resultElement);
    this._bindResultAnchorEvent();
  },

  _bindResultAnchorEvent: function() {
    $('.popup_result a').click(function(e) {
      return Admin.FieldSearch.Result.click(this, e);
    });
  }
}

Admin.FieldSearch.ResultsPopupDrawing = {
  drawResults: function(input, resultElement) {
    var resultHtml  = '',
        inputId     = $(input).attr('id'),
        jsonResults = Admin.FieldSearch.lastResults;

    for(i = 0; i < jsonResults.length; i++) {
      var name   = jsonResults[i].name,
          id     = jsonResults[i].id,
          suffix = '',
          anchorClass = '';

      resultHtml += '<li>';
      /**
        If the typed entity already exists in the results list, fill in the form
        with the current entity's id.
      */
      if (Admin.FieldSearch.selectedResult == id ||
          ( !Admin.FieldSearch.selectedResult &&
            name.toLowerCase() == $(input).val().toLowerCase() ) )
      {

        Admin.FieldSearch.Result.setId(inputId, id);
        Admin.FieldSearch.selectedResult = id;
        suffix = '<span class="current_arrow">►</span> ';
        anchorClass = 'current';
      }

      resultHtml += suffix;
      resultHtml += '<a href="#" class="'+anchorClass+'" data-input-id="'+inputId+'" data-id="'+ id +'">';
      resultHtml += name;
      resultHtml += '</a>';
      resultHtml += '</li>';

    }

    $(resultElement).append('<ul class="search_result">' + resultHtml + '</ul>');
  }
}

Admin.FieldSearch.Result = {
  click: function(_this, e) {
    var textFieldId = $(_this).data('input-id'),
        entityId    = $(_this).data('id'),
        entityName  = $(_this).html();

    var textField   = $('#' + $(_this).data('input-id'));

    this.setId(textFieldId, entityId);
    textField.val(entityName);

    this._hideSearchPopup();
    return false;
  },

  setId: function(textFieldId, id) {
    var targetField = Admin.FieldSearch.idField(textFieldId);
    targetField.val(id);
  },

  _hideSearchPopup: function() {
    Admin.FieldSearch.removePopup();
  }
}
