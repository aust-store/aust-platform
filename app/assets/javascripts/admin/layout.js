$(function(){

  // faux-column
  if( $("#navigation").height() < $("#main").height() )
    $("#navigation").css('height', $("#main").height());
  else
    $("#main").css('height', $("#navigation").height());

});