function contextMenus(){}

var contextMenu = new contextMenus();

// Entry point
//
// Show the context menu based on the eventTarget element.
contextMenus.prototype.show = function(eventTarget){
  this.eventTarget = $(eventTarget);

  this.setMouseOver();
  this.timer = setTimeout(function(){
    contextMenu.setContextMenuHtml();
    contextMenu.setPosition();
    contextMenu.element().fadeIn(60);
  }, 300);
}

contextMenus.prototype.setMouseOver = function(){
  this.element().add(this.eventTarget).hover(function(){
    clearTimeout(contextMenu.mouseOutTimer)
  });
  this.element().mouseleave(function(){
    clearTimeout(contextMenu.timer);
    contextMenu.hide();
  });
  this.eventTarget.mouseleave(function(){
    clearTimeout(contextMenu.timer);
  });
}

contextMenus.prototype.hide = function(){
  contextMenu.mouseOutTimer = setTimeout(function(){
    contextMenu.element().hide();
  }, 100);
}

// Properties
contextMenus.prototype.timer         = null;
contextMenus.prototype.mouseOutTimer = null;
contextMenus.prototype.eventTarget   = null;

contextMenus.prototype.element = function(){
  return $("#context_menu_placeholder");
}

contextMenus.prototype.elementContainer = function(){
  return this.element().find(".context_menu_placeholder_container");
}

contextMenus.prototype.globalPageElement = function(){
  return $("#global > .global_container");
}

// Based on the eventTarget, it sets the context menu content.
contextMenus.prototype.setContextMenuHtml = function(){
  var html = this.eventTarget.find(".html_template.context_menu_template").html();
  this.elementContainer().html(html);
}

contextMenus.prototype.setPosition = function(){
  var left  = this.eventTarget.offset().left;
  var top   = this.eventTarget.offset().top;
  var eventTargetCenter = (this.eventTarget.outerWidth(false)/2);
  left = left - (this.width()/2) + eventTargetCenter;
  left = this.validLeft(left);
  this.element().css({"left": left+"px", "top": top+"px"});
}

contextMenus.prototype.width = function(){
  return this.elementContainer().find(".context_menu").outerWidth(true);
}

contextMenus.prototype.validLeft = function(newDefinedLeft){
  var minimumLeft = this.globalPageElement().offset().left;
  var maximumRight = minimumLeft + this.globalPageElement().outerWidth(true);

  // Verifies the left limit
  if(newDefinedLeft < minimumLeft)
    newDefinedLeft = minimumLeft - 7;

  // Verifies the right limit
  if((newDefinedLeft + this.width()) > maximumRight)
    newDefinedLeft = maximumRight + 7 - this.width();

  return newDefinedLeft;
}
