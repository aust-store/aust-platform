App.Router.reopen({
  enableLogging: true,
  rootURL: '/'
});

App.Router.map(function() {
  this.resource('carts', function() {
    this.route('new');
  });
  this.resource('orders', function() {

  });
});
