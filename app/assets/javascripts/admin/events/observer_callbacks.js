$(document).ready(function(){
  $("[data-observe-callback]").each(function(index){

  });

  observerCallbacks.add("good.price", goodPriceCallback);
});

function goodPriceCallback(priceValue){
  if (priceValue == ""){
    $(".current_price .not_on_sale").css("display", "block");
    $(".current_price .on_sale").hide();
  } else {
    $(".current_price .not_on_sale").hide();
    $(".current_price .on_sale").css("display", "block");
  }
}
