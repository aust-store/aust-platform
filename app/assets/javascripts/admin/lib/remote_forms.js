function remoteForms() {}

var remoteForm = new remoteForms();

$(document).ready(function(){ remoteForm.observe() });

remoteForms.prototype.observe = function(){
  this.removeFlashMessagesOnSubmit();
  this.saveOriginalFormValues();
  this.onSuccessEvent();
  this.onError();
}

remoteForms.prototype.removeFlashMessagesOnSubmit = function(){
  $("form[data-remote='true']").find("div.notice, div.failure").remove();
}

remoteForms.prototype.saveOriginalFormValues = function(){
  // TODO include selects, checkboxes, radios and textareas
  $("form[data-remote='true']").find("input").each(function(index, input) {
    $(input).data("value", $(input).val());
  });
}

remoteForms.prototype.onSuccessEvent = function(){
  var _this = this;
  $("form[data-remote='true']").bind('ajax:success', function(e, xhr, status) {
    _this.onSuccess(e, xhr, status);
  });
}

remoteForms.prototype.onSuccess = function(e, xhr, status){
  try {
    observer.update($.parseJSON(xhr.responseText));
  } catch(e) { }
  $(e.target).prepend(this.noticeTemplate());
  var notice = $(e.target).find(".notice");
  notice.html(i18n.form_success);
  this.hideFlash(notice);
}

remoteForms.prototype.onError = function(){
  var _this = this;
  $("form[data-remote='true']").bind('ajax:error', function(e, xhr, status) {
    if (xhr.status >= 200 && xhr.status <= 299)
      return _this.onSuccess(e, xhr, status);

    $(e.target).prepend(_this.failureTemplate());
    var failure = $(e.target).find(".failure");
    if (typeof $.parseJSON(xhr.responseText) == 'object')
      var response = $.parseJSON(xhr.responseText).errors.join(", ");
    else
      var response = i18n.form_failure;

    failure.html(response);
    _this.rollbackValuesOnFailure($(e.target));
    _this.hideFlash(failure);
  });
}

remoteForms.prototype.rollbackValuesOnFailure = function(form) {
  form.find("input").each(function(index, input) {
    $(input).val($(input).data("value"));
  });
}

remoteForms.prototype.hideFlash = function(flashElement) {
  setTimeout(function() { flashElement.fadeOut(); }, 8000);
}

remoteForms.prototype.noticeTemplate = function() {
  return $(".html_template .js_notice").html();
}

remoteForms.prototype.failureTemplate = function() {
  return $(".html_template .js_failure").html();
}
