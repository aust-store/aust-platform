$(document).ready(function() {

  //jquery cycle plugin
  if ($(".main_page_central_transitional_banners *").length) {
    $(".main_page_central_transitional_banners").cycle({
      activePagerClass: "active",
      pager: ".main_page_central_transitional_banners_navigation"
    });
  }

});
