//
// MAIN
//

window.onload = function () {
    var filePath = '../data/data.tsv';
    var data = getObjectFromTSV(getFileData(filePath));

    var margin = 1,
        width  = 1000 - margin,
        height = 1000 - margin;

    var svg = d3.select("body")
        .append("svg")
            .attr("width" , width  + margin)
            .attr("height", height + margin);

    var circles = svg.selectAll("circle")
        .data(data)
        .enter()
        .append("circle");

    var x_extent = d3.extent(data, function(d) {
            return d.time;
        });
    var x_scale  = d3.scale.linear()
            .range([margin, width])
            .domain(x_extent);
    var x_axis   = d3.svg.axis().scale(x_scale);

    var y_extent = d3.extent(data, function(d) {
            return d.count;
        });
    var y_scale  = d3.scale.linear()
            .range([height, margin])
            .domain(y_extent);
    var y_axis   = d3.svg.axis().scale(y_scale).orient("left");

    // plot data
    d3.selectAll("circle")
        .attr("cx", function(d) {
            return x_scale(d.time);
        })
        .attr("cy", function(d) {
            return y_scale(d.count);
        })
        .attr("r", 1);

    // axis
    d3.select("svg")
        .append("g")
            .attr("class", "x axis")
            .attr("class", "y axis")
            .attr("transform", "translate(0," + height + ")")
            .attr("transform", "translate(" + margin + ", 0 )")
        .call(x_axis)
        .call(y_axis);

    // axis title
    d3.select(".x.axis")
        .append("text")
            .text("time")
            .attr("x", (width / 2) - margin)
            .attr("y", margin / 1.5);

    d3.select(".y.axis")
        .append("text")
            .text("count")
            .attr("transform", "rotate (-90, " + -margin + ", 0)");

    // line
    var line = d3.svg.line()
        .x(function(d) {
            return x_scale(d.time);
        })
        .y(function(d) {
            return y_scale(d.count);
        });

    d3.select("svg")
        .append("path")
            .attr("d", line(data))

//  circles.attr("cx", function(d, i) {
//          return (i * 50) + 25;
//      })
//      .attr("cy", height/2)
//      .attr("r", function(d) {
//          return d;
//      })
//      .attr("fill", "yellow")
//      .attr("stroke", "orange")
//      .attr("stroke-width", function(d) {
//          return d/8;
//      });

//  d3.select("body").selectAll("div")
//      .data(dataset)
//      .enter()
//      .append("div")
//      .attr("class", "bar")
//      .style("height", function(d) {
//          var barHeight = d * 5;
//          return barHeight + "px";
//      });

};

//
// XHR
//

function getFileData (filePath) {
    var fileData;
    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', filePath, false);
    xmlHttpRequest.send(null);
    fileData = xmlHttpRequest.responseText;
    return fileData
}

function getObjectFromTSV (tsvString) {
    var array = _(tsvString.split('\r\n'))
            .chain()
            .initial()
            .map(function (str) { return str.split('\t'); })
            .value();
    var key = _.first(array);
    var vals = _.rest(array);
    return _(vals).map(function (val) { return _.object(key, val); });
}

function getObjectFromCSV (csvString) {
    var array = _(tsvString.split('\r\n'))
            .chain()
            .initial()
            .map(function (str) { return str.split(','); })
            .value();
    var key = _.first(array);
    var vals = _.rest(array);
    return _(vals).map(function (val) { return _.object(key, val); });
}

