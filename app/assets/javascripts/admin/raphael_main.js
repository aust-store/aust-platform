$(function(){
  
  if( $("#pie_chart").length > 0 )
    graphs();

});

function graphs(){
  var data1 = {
    items: [
      {label: 'One', data: 12015},
      {label: 'Two', data: 23834},
      {label: 'Three', data: 24689}
    ]
  };

  var data2 = {
    items: [
      {label: 'One', data: 12015},
      {label: 'Two', data: 23834},
      {label: 'Three', data: 24689}
    ]
  };

  var data3 = {
    items: [
      {label: 'One', data: 1015},
      {label: 'Two', data: 2834},
      {label: 'Three', data: 4689}
    ]
  };
  //Push our data into two separate arrays
  var labels1 = [];
  var values1 = [];
   for (i in data1.items) {
     var item = data1.items[i];
     labels1.push(item.label);
     values1.push(item.data);
   }

  var labels2 = [];
  var values2 = [];
   for (i in data2.items) {
     var item = data2.items[i];
     labels2.push(item.label);
     values2.push(item.data);
   }

  var labels3 = [];
  var values3 = [];
  for (i in data3.items) {
    var item = data3.items[i];
    labels3.push(item.label);
    values3.push(item.data);
  }

  var r = Raphael($("#pie_chart")[0]);
  var pie = r.piechart(60, 60, 50, values1, {legend: labels1, legendpos: "east"});

  var r_two = Raphael($("#pie_chart_two")[0]);
  var pie_two = r_two.piechart(60, 60, 50, values2, {legend: labels2, legendpos: "east"});

  var r_three = Raphael($("#pie_chart_three")[0]);
  var pie_three = r_three.piechart(60, 60, 50, values3, {legend: labels3, legendpos: "east"});

  pie.attr({opacity: 0.7});
  pie.hover(function () {
    this.sector.stop();
    this.sector.animate({opacity: 1}, 500);
    this.sector.animate({ transform: 's1.05 1.05 ' + this.cx + ' ' + this.cy }, 500, "bounce");
    if (this.label) {
      this.label[0].stop();
      this.label[0].attr({ r: 6 }, 800, "bounce");
      this.label[1].attr({ "font-weight": 800 });
    }
  }, function () {
    this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");
    this.sector.attr({opacity: 0.7});

    if (this.label) {
        this.label[0].attr({ r: 5 }, 500, "bounce");
        this.label[1].attr({ "font-weight": 400 });
    }
  });

}