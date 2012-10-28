$(document).ready(function(){
  $('input[placeholder],textarea[placeholder]').placeholder();

  var History = window.History;
  if ( History.enabled ) {
    // Bind to StateChange Event
    History.Adapter.bind(window, 'statechange', function(){
      var State = History.getState();
      if (State.data.refresh !== false)
        window.location = State.url;
    });
  }
});
