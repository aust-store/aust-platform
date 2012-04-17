$(document).ready(function(){
  $(".thumbs_gallery .box.image").on({
    mouseover: function(){
      $(this).find(".delete").show();
    }, 
    mouseout: function(){
      $(this).find(".delete").hide();
    }
  });
});
