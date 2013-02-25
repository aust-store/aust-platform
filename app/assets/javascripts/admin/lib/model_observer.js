// Observes the whole document for [data-observe] elements. Whenever an Ajax
// call is made, the JSON response should be passed in to
//
//   observer.update(response)
//
// It will update all the elements in the document with the JSON data.
//
// Example:
//
//   JSON: {"item":{"name":"My item", "price":"US$40,00"}}
//
//   Document:
//
//     <span data-observe="item.name"></span>
//     <span data-observe="item.price"></span>
//
// The first HTML element will be updated with "My item" automatically and
// the second, price, with "US$40,00".
//
function modelObserver(){}

var observer = new modelObserver();
modelObserver.prototype.update = function(jsonData){
  for(callback in observerCallbacks.callbacksList) {
    //observerCallbacks.run(observing, currentValue);
  }

  for(observing in observerCallbacks.callbacksList) {
    var currentValue = observer.currentValue(observing, jsonData);

    if (typeof currentValue != "undefined")
      observerCallbacks.run(observing, currentValue);
  }

  $("[data-observe]").each(function(index){
    var observing = $(this).data("observe");
    var currentValue = observer.currentValue(observing, jsonData);
    if (typeof currentValue == "string") {
      observerCallbacks.run(observing, currentValue);
      $(this).html(currentValue);
    }
  });
};

modelObserver.prototype.currentValue = function(observing, jsonData) {
  var observedResources = observing.split("."),
      currentValue = jsonData;

  $.each(observedResources, function(index, value){
    if (currentValue[value] || typeof currentValue[value] != "undefined")
      currentValue = currentValue[value];
    else
      currentValue = undefined;
  });

  return currentValue;
}
