$(document).ready(function(){
  $('input[placeholder],textarea[placeholder]').placeholder();

  /* selectize.js */
  $("input.js_taggable").selectize({
    plugins: ['restore_on_backspace', 'remove_button'],
    delimiter: ',',
    persist: true,
    preload: false,
    load: function(query, callback) {
      callback(this.$input.data('data'));
    },
    render: {
      option_create: function(item, escape) {
        var input = item.input;
        return '<div class="create">' +
          (input ? '<span class="caption">Criar <b>' + escape(input) + '</b></span>' : '') +
          '</div>';
      },
    },
    create: function(input) {
      return {
        value: input,
        text: input
      }
    }
  });

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
