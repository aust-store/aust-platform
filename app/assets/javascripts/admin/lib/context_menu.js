function contextMenus(){}

var contextMenu = new contextMenus();
contextMenus.prototype.show = function(context_menu_element){
  this.timer = setTimeout(function(){
    contextMenu.hide();
    context_menu_element.fadeIn(60);
  }, 300);
}

contextMenus.prototype.hide = function(){
  clearTimeout(this.timer);
  $(".context_menu").hide();
}

contextMenus.prototype.timer = null;
