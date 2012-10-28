function loadingOperations(){}

var loading = new loadingOperations();
loadingOperations.prototype.show = function(_element){
  var $element = $(_element);
  $element.css({ position: 'relative', display: 'table' })
  $element.append($("#loading_timer").html());
  $element.find(".loading_box").fadeIn();
  this.showTimeoutText($element);
}

loadingOperations.prototype.hide = function(){
  $("#global .loading_box").remove();
}

loadingOperations.prototype.showTimeoutText = function(_element){
  $element = $(_element);
  setTimeout(function(){
    $element.find(".text").hide();
    $element.find(".text.timeout").show();

    setTimeout(function(){
      loading.hide();
    }, 4000);
  }, 15000);
}
