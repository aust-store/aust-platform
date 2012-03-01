$(function(){

  // faux-column
  if( $("#navigation").height() < $("#main").height() )
    $("#navigation").css('min-height', $("#main").height());
  else
    $("#main").css('min-height', $("#navigation").height());

});