$(document).ready(function(){
  var onSale = $(".inventory_entries.update_on_sale");
  if(onSale.find("input[type=checkbox]").length == 0)
    return false;

  onSale.on("click", "input.inventory_entry_on_sale", function(){
    var checkbox = $(this);
    var checked = (checkbox.is(":checked")) ? true : false;

    $.ajax({
      url: checkbox.data("url"),
      data: {
        inventory_entry: {
          on_sale: (checked ? "1" : "0")
        }
      },
      type: "PUT",
      dataType: "json"
    }).done(function(json_response) {
      observer.update(json_response);
    }).fail(function(response) {
      checkbox.attr("checked", !checked);
    });
  });
});
