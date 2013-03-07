$(document).ready(function(){

  // inventory item's images management
  $("#js_image_management").on("click mouseenter", "div.box.image", function(e){
    e.stopPropagation();

    var image = $(e.target),
        menu;

    if (image.get(0).tagName != "IMG")
      image = image.find("img");

    menu = image.parents("div.box.image");
    contextMenu.show(menu);
  });

  $("#js_image_management").on("mouseleave", "div.box.image", function(e){
    contextMenu.hide();
  });
});
