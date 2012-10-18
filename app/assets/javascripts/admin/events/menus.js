$(document).ready(function(){

  // inventory item's images management
  $("#js_image_management div.box.image").on({
    click: function(e){
      var context_menu = $(e.target).parents("div.box.image").find(".image.context_menu");
      contextMenu.show(context_menu);
    }, 
    mouseenter: function(e){
      e.target.click();
    }, 
    mouseleave: function(e){
      contextMenu.hide();
    }
  });
});
