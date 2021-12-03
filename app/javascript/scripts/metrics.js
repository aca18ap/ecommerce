// For some reason the Gem won't fetch the package
import * as d3 from "/home/liam/.rvm/gems/ruby-2.7.4/gems/d3-rails-7.0.0/app/assets/javascripts/d3.js"

document.addEventListener('DOMContentLoaded', () => {
  const pageVisitedFrom = Date.now();
  const CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
  const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

  // Load the graph of page visits
  drawBarPlot();

  // Bind listener to the visibilitychange event instead of unload, find out more at:
  // https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon#sending_analytics_at_the_end_of_a_session
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'hidden') {
      let metrics = new FormData();
      metrics.append('pageVisitedFrom', pageVisitedFrom);
      metrics.append('pageVisitedTo', Date.now());
      metrics.append('location', timezone)
      metrics.append('path', window.location.pathname);
      metrics.append('authenticity_token', CSRFToken);

      console.log(metrics);
      // navigator.sendBeacon is the easist way to send a request to the server when a page is unloading.
      // The browser will keep this request alive even if the page that started the request is unloaded already.
      // sendBeacon() will use POST method, and you cannot change this.
      navigator.sendBeacon('/metrics', metrics);


      // fetch with keepalive true behaves the same as navigator.sendBeacon,
      // but allows you to customise headers / method easily.
      // fetch('/metrics', {
      //   method: 'POST',
      //   keepalive: true,
      //   credentials: 'same-origin',
      //   headers: {
      //     'x-csrf-token': CSRFToken
      //   },
      //   body: metrics
      // });

      // Both sendBeacon and fetch + keepalive got a 64kb payload limit. This is across all requests from the same page.
    }
  })
});

function groupBy(xs, key) {
  return xs.reduce(function(rv, x) {
    (rv[x[key]] = rv[x[key]] || []).push(x);
    return rv;
  }, {});
}

function drawBarPlot() {
  // Receives @metrics from controller
  let metrics = gon.metrics;

  let pageVisits = groupBy(metrics, "path")
  let pageVisitsCounts = {}
  Object.keys(pageVisits).forEach(key => {
    pageVisitsCounts[key] = pageVisits[key].length;
  });

  // set the dimensions and margins of the graph
  var margin = {top: 10, right: 30, bottom: 30, left: 60},
  width = 460 - margin.left - margin.right,
  height = 400 - margin.top - margin.bottom;

  // append the svg object to the body of the page
  var svg = d3.select("#visits-barchart-plot")
  .append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform",
  "translate(" + margin.left + "," + margin.top + ")");

  //Read the data
  d3.csv("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/2_TwoNum.csv", function(data) {
    // Add X axis
    var x = d3.scaleLinear()
    .domain([0, 4000])
    .range([ 0, width ]);
    svg.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x));

    // Add Y axis
    var y = d3.scaleLinear()
    .domain([0, 500000])
    .range([ height, 0]);
    svg.append("g")
    .call(d3.axisLeft(y));

    // Add dots
    svg.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
    .attr("cx", function (d) { return x(d.GrLivArea); } )
    .attr("cy", function (d) { return y(d.SalePrice); } )
    .attr("r", 1.5)
    .style("fill", "#69b3a2")
  })

  //document.getElementById('visits-barchart-div').innerText = "GRAPH WILL APPEAR HERE";
}
