$(document).ready(function(){

  // Item has one entry
  if ($("#stop_selling_item").length) {
    observerCallbacks.add("inventory_item.on_sale", saveCurrentOnSaleStatusCallback);
    saveCurrentOnSaleStatusCallback($("#stop_selling_item").data("on-sale") == "1");
  }

  $("#stop_selling_item").on("click", function(){
    var onSale = $(this).data("on-sale") == "1" ? false : true;
    updateEntriesOnSale($(this).data("url"), onSale, null);
  });

  // Item has more than one entry
  var onSale = $(".inventory_entries.update_on_sale");
  if(onSale.find("input[type=checkbox]").length == 0)
    return false;

  onSale.on("click", "input.inventory_entry_on_sale", function(){
    var checkbox = $(this);
    var checked = (checkbox.is(":checked")) ? true : false;

    updateEntriesOnSale(checkbox.data("url"), checked, checkbox);
  });
});

function updateEntriesOnSale(url, onSale, checkbox){
  $.ajax({
    url: url,
    data: {
      inventory_entry: {
        on_sale: (onSale ? "1" : "0")
      }
    },
    type: "PUT",
    dataType: "json"
  }).done(function(json_response) {
    observer.update(json_response);
  }).fail(function(response) {
    if (checkbox)
      checkbox.attr("checked", !onSale);
  });
}

function saveCurrentOnSaleStatusCallback(onSale){
  var button = $("#stop_selling_item");
  if (!onSale){
    button.data("on-sale", "0");
    button.find(".text").html(button.data("not-on-sale-text"));
    $(".js_this_entry_status_not_on_sale").show();
    $(".js_this_entry_status_on_sale").hide();
  } else {
    button.data("on-sale", "1");
    button.find(".text").html(button.data("on-sale-text"));
    $(".js_this_entry_status_on_sale").show();
    $(".js_this_entry_status_not_on_sale").hide();
  }
}
