$(document).ready(function() {
  asyncForm = new AsyncForm.Bindings();
  asyncForm.initialize();
});

var AsyncForm = {}
AsyncForm.Bindings = function() {
  this.initialize = function() {
    setBindings();
  }

  var setBindings = function() {
    $('.form-upload').bind('ajax:complete', function(evt, xhr, status) {
      var elToUpdate = $( $(this).data('update') );

      elToUpdate.html(xhr.responseText);

      $('.form-upload').find('input[type="file"]').val("");
    });
  }
}
