// For some reason the Gem won't fetch the package
import * as d3 from 'd3';
import * as uk from './uk-geo.json';

document.addEventListener('DOMContentLoaded', () => {
    // Receives @metrics and @registrations from controller using gon gem
    let metrics = gon.metrics;
    let registrations = gon.registrations;

    // Create charts to display on metrics page
    const width = 1000;
    const height = 500;

    let emptyCharts = [];


    // Update chart title to include total
    document.getElementById('visits-barchart-title').innerText = `Site Visits by Page (Total: ${metrics.length})`;
    // Only update graphs if there are any site tracking metrics in the system
    if (metrics.length > 0) {
        // Calculate the number of visits to each page
        let pageVisits = groupBy(metrics, "path")
        let pageVisitsCounts = []
        Object.keys(pageVisits).forEach(key => {
            pageVisitsCounts.push({
                page: key,
                visits: pageVisits[key].length
            });
        });

        let pageVisitCountsChart = HorizontalBarChart(pageVisitsCounts, {
            x: d => d.visits,
            y: d => d.page,
            yDomain: d3.groupSort(pageVisitsCounts, ([d]) => -d.visits, d => d.page), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Visits',
            svgElement: document.getElementById('visits-barchart-plot')
        });

        // Group metrics into hours between first recorded visit and now
        let timeVisits = groupByHour(metrics, "from", metrics[0].from);
        let timeVisitsCounts = []

        // Calculate number of visits at a specific time interval
        Object.keys(timeVisits).forEach(key => {
            timeVisitsCounts.push({
                time: key,
                visits: timeVisits[key].length
            });
        });

        let visitsOverTimeChart = LineChart(timeVisitsCounts, {
            x: d => d.time,
            y: d => d.visits,
            yLabel: 'Visits',
            width,
            height,
            color: 'green',
            svgElement: document.getElementById('visits-linechart-plot'),
        });
    } else {
        // Set text of chart areas to indicate that there is no data
        emptyCharts.push(
            document.getElementById('visits-barchart-plot'),
            document.getElementById('visits-linechart-plot'));
    }


    // Update chart title to include total
    document.getElementById('registrations-barchart-title').innerText = `Site Registrations by Vocation (Total: ${registrations.length})`;
    // Only update graphs if there are any registrations in the system
    if (registrations.length > 0) {
        // Calculate the number of visits to each page
        let vocationRegs = groupBy(registrations, "vocation")
        let vocationRegsCounts = []
        Object.keys(vocationRegs).forEach(key => {
            vocationRegsCounts.push({
                vocation: key,
                registrations: vocationRegs[key].length
            });
        });

        let vocationRegsCountsChart = HorizontalBarChart(vocationRegsCounts, {
            x: d => d.registrations,
            y: d => d.vocation,
            yDomain: d3.groupSort(vocationRegsCounts, ([d]) => -d.registrations, d => d.vocation), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Registrations',
            svgElement: document.getElementById('registrations-barchart-plot')
        });

        // Group registrations into hours between first recorded visit and now
        let timeRegs = groupByHour(registrations, "created_at", registrations[0].created_at);
        let timeRegsCounts = []

        // Calculate number of registrations at a specific time interval
        Object.keys(timeRegs).forEach(key => {
            timeRegsCounts.push({
                vocation: 'Total',
                time: key,
                registrations: timeRegs[key].length
            });

            // Calculate number of registrations at a specific time interval for each vocation
            let vocationGrouped = groupBy(timeRegs[key], 'vocation');
            ['Customer', 'Business'].forEach(vocation => {
                timeRegsCounts.push({
                    vocation: vocation,
                    time: key,
                    registrations: vocationGrouped[vocation] ? vocationGrouped[vocation].length : 0
                });
            })
        });

        let regsOverTimeChart = LineChart(timeRegsCounts, {
            x: d => d.time,
            y: d => d.registrations,
            z: d => d.vocation,
            yLabel: 'Registrations',
            width,
            height,
            color: 'green',
            svgElement: document.getElementById('registrations-linechart-plot')
        });
    } else {
        // Set text of chart areas to indicate that there is no data
        emptyCharts.push(
            document.getElementById('registrations-barchart-plot'),
            document.getElementById('registrations-linechart-plot'));
    }

    for (let chart of emptyCharts) {
        console.log(chart);
        let svg = d3.select(chart)
            .attr("width", width)
            .attr("height", height)
            .attr("viewBox", [0, 0, width, height])
            .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

        let g = svg.append("g")
            .attr("transform", function(d, i) {
                return "translate(0,0)";
            });

        g.append("text")
            .attr("x", width / 2)
            .attr("y", height / 2)
            .attr("stroke", "#000")
            .attr("text-anchor", "middle")
            .attr("font-size", "24px")
            .attr("font-family", "Outfit")
            .text("There is no data for this metric yet");
    }


    let svg = d3.select('#registrations-geo-plot');
    let projection = d3.geoAlbers()
        .center([0, 55.4])
        .rotate([4.4, 0])
        .parallels([50, 60])
        .scale(4000)
        .translate([width/5, (2.4*height)/3])

    console.log(uk.features);
    let tempData = [{ID_1: 1, ID_2: 1, value: 1}, {ID_1: 1, ID_2: 2, value: 1}]

    svg.append("g")
        .selectAll("path")
        .data(uk.features)
        .enter()
        .append("path")
        .attr("id", d => { return `county-${d.properties.ID_1}-${d.properties.ID_2}` })
        .attr("fill", "#000")
        .attr("stroke", "white")
        .attr("stroke-width", 0.4)
        .attr("d", d3.geoPath(projection));

    d3.select(`#county-1-65`)
        .attr('fill', '#f00')


});

/**
 * Groups elements of an array of dicts by a certain key
 * @param arr array of dicts to sort
 * @param key key to sort by
 * @returns {*} dict: key is the specified key's value, value is an array of dicts with the specified key's value
 */
function groupBy(arr, key) {
    return arr.reduce(function(rec_var, x) {
        (rec_var[x[key]] = rec_var[x[key]] || []).push(x);
        return rec_var;
    }, {});
}

/**
 * Creates a dict of hours between a start time and assigns
 * @param arr array of dicts to sort
 * @param key string based time key to sort by
 * @param startTime string based time as the start time
 * @returns {{}} dict: key is each hour from start time to now, value is array of dicts, grouped into hours
 */
function groupByHour(arr, key, startTime) {
    let startHour = new Date(Date.parse(startTime)).setMinutes(0, 0, 0);
    let endHour = new Date().setMinutes(0, 0, 0);

    // Create an dict of every hour between the start and end hour
    let hoursDict = {}
    for (let hour = startHour; hour <= endHour; hour += (60*60*1000)) {
        hoursDict[hour] = [];
    }

    // Sum the number of visits and assign them to groups of hours
    for (let a of arr) {
        let aDate = new Date(Date.parse(a[key])).setMinutes(0, 0, 0);
        hoursDict[aDate].push(a);
    }

    return hoursDict
}

// Copyright 2021 Observable, Inc.
// Released under the ISC license.
// https://observablehq.com/@d3/bar-chart
// Modified
function HorizontalBarChart(data, {
    x = d => d, // given d in data, returns the (quantitative) x-value
    y = (d, i) => i, // given d in data, returns the (ordinal) y-value
    title, // given d in data, returns the title text
    marginTop = 30, // the top margin, in pixels
    marginRight = 0, // the right margin, in pixels
    marginBottom = 10, // the bottom margin, in pixels
    marginLeft = 30, // the left margin, in pixels
    width = 640, // the outer width of the chart, in pixels
    height, // outer height, in pixels
    xType = d3.scaleLinear, // type of x-scale
    xDomain, // [xmin, xmax]
    xRange = [marginLeft, width - marginRight], // [left, right]
    xFormat, // a format specifier string for the x-axis
    xLabel, // a label for the x-axis
    yPadding = 0.1, // amount of y-range to reserve to separate bars
    yDomain, // an array of (ordinal) y-values
    yRange, // [top, bottom]
    color = "currentColor", // bar fill color
    titleColor = "white", // title fill color when atop bar
    titleAltColor = "currentColor", // title fill color when atop background
    svgElement
} = {}) {
    // Compute values.
    const X = d3.map(data, x);
    const Y = d3.map(data, y);

    // Compute default domains, and unique the y-domain.
    if (xDomain === undefined) xDomain = [0, d3.max(X)];
    if (yDomain === undefined) yDomain = Y;
    yDomain = new d3.InternSet(yDomain);

    // Omit any data not present in the y-domain.
    const I = d3.range(X.length).filter(i => yDomain.has(Y[i]));

    // Compute the default height.
    if (height === undefined) height = Math.ceil((yDomain.size + yPadding) * 25) + marginTop + marginBottom;
    if (yRange === undefined) yRange = [marginTop, height - marginBottom];

    // Construct scales and axes.
    const xScale = xType(xDomain, xRange);
    const yScale = d3.scaleBand(yDomain, yRange).padding(yPadding);
    const xAxis = d3.axisTop(xScale).ticks(width / 80, xFormat);
    const yAxis = d3.axisLeft(yScale).tickSizeOuter(0);

    // Compute titles.
    if (title === undefined) {
        const formatValue = xScale.tickFormat(100, xFormat);
        title = i => `${formatValue(X[i])}`;
    } else {
        const O = d3.map(data, d => d);
        const T = title;
        title = i => T(O[i], i, data);
    }

    const svg = d3.select(svgElement)
        .attr("width", width)
        .attr("height", height)
        .attr("viewBox", [0, 0, width, height])
        .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

    svg.append("g")
        .attr("transform", `translate(0,${marginTop})`)
        .call(xAxis)
        .call(g => g.select(".domain").remove())
        .call(g => g.selectAll(".tick line").clone()
            .attr("y2", height - marginTop - marginBottom)
            .attr("stroke-opacity", 0.1))
        .call(g => g.append("text")
            .attr("x", width - marginRight)
            .attr("y", -22)
            .attr("fill", "currentColor")
            .attr("text-anchor", "end")
            .text(xLabel));

    svg.append("g")
        .attr("fill", color)
        .selectAll("rect")
        .data(I)
        .join("rect")
        .attr("x", xScale(0))
        .attr("y", i => yScale(Y[i]))
        .attr("width", i => xScale(X[i]) - xScale(0))
        .attr("height", yScale.bandwidth())

    svg.append("g")
        .attr("fill", titleColor)
        .attr("text-anchor", "end")
        .attr("font-family", "sans-serif")
        .attr("font-size", 10)
        .selectAll("text")
        .data(I)
        .join("text")
        .attr("x", i => xScale(X[i]))
        .attr("y", i => yScale(Y[i]) + yScale.bandwidth() / 2)
        .attr("dy", "0.35em")
        .attr("dx", -4)
        .text(title)
        .call(text => text.filter(i => xScale(X[i]) - xScale(0) < 20) // short bars
            .attr("dx", +4)
            .attr("fill", titleAltColor)
            .attr("text-anchor", "start"));

    svg.append("g")
        .attr("transform", `translate(${marginLeft},0)`)
        .call(yAxis);

    return svg.node();
}

// Copyright 2021 Observable, Inc.
// Released under the ISC license.
// https://observablehq.com/@d3/multi-line-chart
// Modified
function LineChart(data, {
    x = ([x]) => x, // given d in data, returns the (temporal) x-value
    y = ([, y]) => y, // given d in data, returns the (quantitative) y-value
    z = () => 1, // given d in data, returns the (categorical) z-value
    title, // given d in data, returns the title text
    defined, // for gaps in data
    curve = d3.curveLinear, // method of interpolation between points
    marginTop = 20, // top margin, in pixels
    marginRight = 30, // right margin, in pixels
    marginBottom = 30, // bottom margin, in pixels
    marginLeft = 40, // left margin, in pixels
    width = 640, // outer width, in pixels
    height = 400, // outer height, in pixels
    xType = d3.scaleUtc, // type of x-scale
    xDomain, // [xmin, xmax]
    xRange = [marginLeft, width - marginRight], // [left, right]
    yType = d3.scaleLinear, // type of y-scale
    yDomain, // [ymin, ymax]
    yRange = [height - marginBottom, marginTop], // [bottom, top]
    yFormat, // a format specifier string for the y-axis
    yLabel, // a label for the y-axis
    zDomain, // array of z-values
    color = "currentColor", // stroke color of line, as a constant or a function of *z*
    strokeLinecap, // stroke line cap of line
    strokeLinejoin, // stroke line join of line
    strokeWidth = 1.5, // stroke width of line
    strokeOpacity, // stroke opacity of line
    mixBlendMode = "multiply", // blend mode of lines
    voronoi, // show a Voronoi overlay? (for debugging)
    svgElement
} = {}) {
    // Compute values.
    const X = d3.map(data, x);
    const Y = d3.map(data, y);
    const Z = d3.map(data, z);
    const O = d3.map(data, d => d);
    if (defined === undefined) defined = (d, i) => !isNaN(X[i]) && !isNaN(Y[i]);
    const D = d3.map(data, defined);

    // Compute default domains, and unique the z-domain.
    if (xDomain === undefined) xDomain = d3.extent(X);
    if (yDomain === undefined) yDomain = [0, d3.max(Y)];
    if (zDomain === undefined) zDomain = Z;
    zDomain = new d3.InternSet(zDomain);

    // Omit any data not present in the z-domain.
    const I = d3.range(X.length).filter(i => zDomain.has(Z[i]));

    // Construct scales and axes.
    const xScale = xType(xDomain, xRange);
    const yScale = yType(yDomain, yRange);
    const xAxis = d3.axisBottom(xScale).ticks(width / 80).tickSizeOuter(0);
    const yAxis = d3.axisLeft(yScale).ticks(height / 60, yFormat);

    // Compute titles.
    const T = title === undefined ? Z : title === null ? null : d3.map(data, title);

    // Construct a line generator.
    const line = d3.line()
        .defined(i => D[i])
        .curve(curve)
        .x(i => xScale(X[i]))
        .y(i => yScale(Y[i]));

    const svg = d3.select(svgElement)
        .attr("width", width)
        .attr("height", height)
        .attr("viewBox", [0, 0, width, height])
        .attr("style", "max-width: 100%; height: auto; height: intrinsic;")
        .style("-webkit-tap-highlight-color", "transparent")
        .on("pointerenter", pointerentered)
        .on("pointermove", pointermoved)
        .on("pointerleave", pointerleft)
        .on("touchstart", event => event.preventDefault());

    // An optional Voronoi display (for fun).
    if (voronoi) svg.append("path")
        .attr("fill", "none")
        .attr("stroke", "#ccc")
        .attr("d", d3.Delaunay
            .from(I, i => xScale(X[i]), i => yScale(Y[i]))
            .voronoi([0, 0, width, height])
            .render());

    svg.append("g")
        .attr("transform", `translate(0,${height - marginBottom})`)
        .call(xAxis);

    svg.append("g")
        .attr("transform", `translate(${marginLeft},0)`)
        .call(yAxis)
        .call(g => g.select(".domain").remove())
        .call(voronoi ? () => {} : g => g.selectAll(".tick line").clone()
            .attr("x2", width - marginLeft - marginRight)
            .attr("stroke-opacity", 0.1))
        .call(g => g.append("text")
            .attr("x", -marginLeft)
            .attr("y", 10)
            .attr("fill", "currentColor")
            .attr("text-anchor", "start")
            .text(yLabel));

    const path = svg.append("g")
        .attr("fill", "none")
        .attr("stroke", typeof color === "string" ? color : null)
        .attr("stroke-linecap", strokeLinecap)
        .attr("stroke-linejoin", strokeLinejoin)
        .attr("stroke-width", strokeWidth)
        .attr("stroke-opacity", strokeOpacity)
        .selectAll("path")
        .data(d3.group(I, i => Z[i]))
        .join("path")
        .style("mix-blend-mode", mixBlendMode)
        .attr("stroke", typeof color === "function" ? ([z]) => color(z) : null)
        .attr("d", ([, I]) => line(I));

    const dot = svg.append("g")
        .attr("display", "none");

    dot.append("circle")
        .attr("r", 2.5);

    dot.append("text")
        .attr("font-family", "sans-serif")
        .attr("font-size", 10)
        .attr("text-anchor", "middle")
        .attr("y", -8);

    function pointermoved(event) {
        const [xm, ym] = d3.pointer(event);
        const i = d3.least(I, i => Math.hypot(xScale(X[i]) - xm, yScale(Y[i]) - ym)); // closest point
        path.style("stroke", ([z]) => Z[i] === z ? null : "#ddd").filter(([z]) => Z[i] === z).raise();
        dot.attr("transform", `translate(${xScale(X[i])},${yScale(Y[i])})`);
        if (T) dot.select("text").text(T[i]);
        svg.property("value", O[i]).dispatch("input", {bubbles: true});
    }

    function pointerentered() {
        path.style("mix-blend-mode", null).style("stroke", "#ddd");
        dot.attr("display", null);
    }

    function pointerleft() {
        path.style("mix-blend-mode", "multiply").style("stroke", null);
        dot.attr("display", "none");
        svg.node().value = null;
        svg.dispatch("input", {bubbles: true});
    }

    return Object.assign(svg.node(), {value: null});
}