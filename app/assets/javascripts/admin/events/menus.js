$(document).ready(function(){

  // inventory item's images management
  $("#js_image_management").on("click mouseenter", "div.box.image", function(e){
    var menu = $(e.target).parents("div.box.image").find(".image.context_menu");
    contextMenu.show(menu);
  });

  $("#js_image_management").on("mouseleave", "div.box.image", function(e){
    contextMenu.hide();
  });
});
