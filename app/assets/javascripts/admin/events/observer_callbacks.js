$(document).ready(function(){
  observerCallbacks.add("inventory_item.on_sale", itemPriceCallback);
});

function itemPriceCallback(priceValue){
  if (priceValue) {
    $(".current_price .not_on_sale").hide();
    $(".current_price .on_sale").css("display", "block");
  } else {
    $(".current_price .not_on_sale").css("display", "block");
    $(".current_price .on_sale").hide();
  }
}
