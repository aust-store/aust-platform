$(function(){
  
  var data = {
    items: [
      {label: 'Tênis', data: 12015},
      {label: 'Camisetas', data: 23834},
      {label: 'Calças', data: 24689}
    ]
  };

  //Push our data into two separate arrays
  var labels = [];
  var values = [];
   for (i in data.items) {
     var item = data.items[i];
     labels.push(item.label);
     values.push(item.data);
   }

  var r = Raphael("pie_chart");
  var pie = r.piechart(60, 60, 50, values, {legend: labels, legendpos: "east"});
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

})