var Admin = {};

Admin.FieldSearch = {
  init: function() {
    var that = this;
    $('input[data-search-url]').keyup(function(event){
      var input = $(this);

      that.clearId(input);

      $.ajax({
        url: input.data('search-url'),
        data: { search: input.val() },
        dataType: "json",
        complete: function(response) {
          response = $.parseJSON(response.responseText);
          Admin.FieldSearch.ResultsPopup.showResults(response, input);
        }
      });
    });
  },

  clearId: function(input) {
    var idField = this.idField(input.attr('id'));
    idField.val('');
  },

  idField: function(textFieldId) {
    return $('#' + textFieldId + '_id');
  }
}

$(document).ready(function(){
  Admin.FieldSearch.init()
});

//var Admin = {};

Admin.FieldSearch.ResultsPopup = {
  showResults: function(responseJson, input) {
    var popupResult = this._createPopup();
    this._prepareInput(input);
    this._populateResultPopup(input, popupResult, responseJson);
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

  _populateResultPopup: function(input, resultElement, responseJson) {
    var entity;
    var inputId = $(input).attr('id');

    for(key in responseJson) {
      entity = responseJson[key];
      break;
    }

    var resultHtml = '';
    for(i = 0; i < entity.length; i++) {
      var name   = entity[i].name,
          id     = entity[i].id,
          suffix = '',
          anchorClass = '';

      resultHtml += '<li>';
      /**
        If the typed entity already exists in the results list, fill in the form
        with the current entity's id.
      */
      if( name.toLowerCase() == $(input).val().toLowerCase() ) {
        Admin.FieldSearch.Result.setId(inputId, id);
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
  },

  _showResultPopup: function(input, resultElement) {
    $('.popup_result').remove();
    input.parent().append(resultElement);
    this._bindResultAnchorEvent();
  },

  _bindResultAnchorEvent: function() {
    $('.popup_result a').click(function(e) {
      return Admin.FieldSearch.Result.click(this, e);
    });
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
    $('.popup_result').remove();
  }
}
