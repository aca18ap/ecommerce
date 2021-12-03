// For some reason the Gem won't fetch the package
import * as d3 from "d3"

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
  let pageVisitsCounts = []
  Object.keys(pageVisits).forEach(key => {
    pageVisitsCounts.push({
      page: key,
      visits: pageVisits[key].length
    });
  });

  console.log(typeof(pageVisitsCounts))

  const width = 500;
  const height = 500;

  var x = d3.scaleOrdinal().range([0, width]);
  var y = d3.scaleLinear().range([height, 0]);

  x.domain(pageVisitsCounts.map(d => d.page));
  y.domain([0, d3.max(pageVisitsCounts, d => d.visits)]);

  let svg = d3.selectAll('#visits-barchart-plot')
      .attr("width", width)
      .attr("height", height);

  svg.selectAll("bar")
      .data(pageVisitsCounts)
      .enter().append("rect")
      .style("fill", "steelblue")
      .attr("x", d => x[d.page])
      .attr("width", 10)
      .attr("y", d => y(d.visits))
      .attr("height", d => height - y(d.visits));

}