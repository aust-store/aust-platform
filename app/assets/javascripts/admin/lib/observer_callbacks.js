// Manages the Observer callbacks. Works with modelObserver object.
//
// When the modelObserver is called, it updates the document elements. Before
// the update starts, you can define callback functions. They are called right
// before the document is updated.
//
// For exampleL
//
//   function goodPriceCallback(value) { // do something }
//
//   observerCallbacks.add("item.price", goodPriceCallback);
//
// This way, whenever item.price is going to be modified by modelObserver,
// goodPriceCallback is called.
//
function modelObserverCallbacks(){}

var observerCallbacks = new modelObserverCallbacks();
modelObserverCallbacks.prototype.callbacksList = new Object;
modelObserverCallbacks.prototype.add = function(resource, callback){
  if (typeof this.callbacksList[resource] == 'undefined')
    this.callbacksList[resource] = [];

  this.callbacksList[resource].push(callback);
};

modelObserverCallbacks.prototype.run = function(resource, value){
  if (typeof this.callbacksList[resource] == 'undefined')
    return false;

  for (i=0; i < this.callbacksList[resource].length; i++){
    this.callbacksList[resource][i](value);
  }
}
