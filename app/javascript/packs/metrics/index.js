// For some reason the Gem won't fetch the package
import * as d3 from 'd3';
import * as uk from './uk-geo.json';

document.addEventListener('DOMContentLoaded', () => {
    // Create charts to display on metrics page
    const width = 1000;
    const height = 500;

    let emptyCharts = [];

    // Only update graphs if there are any site tracking metrics in the system
    if (gon.visits && gon.visits.length > 0) {
        // Gets pageVisits from gon gem - calculated in CalculateMetrics service class
        let pageVisitCountsChart = HorizontalBarChart(gon.pageVisits, {
            x: d => d.visits,
            y: d => d.page,
            yDomain: d3.groupSort(gon.pageVisits, ([d]) => -d.visits, d => d.page), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Visits',
            svgElement: document.getElementById('visits-barchart-plot')
        });

        // Gets timeVisits from gon gem - calculated in CalculateMetrics service class
        let visitsOverTimeChart = LineChart(gon.timeVisits, {
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

    let projection = d3.geoAlbers()
        .center([0, 55.4])
        .rotate([4.4, 0])
        .parallels([50, 60])
        .scale(4000)
        .translate([width / 5, (2.4 * height) / 3])

    const colour = d3.scaleSequential([1, 10], d3.interpolateGreens);
    colour.unknown('#fff');

    let visitsPlotData = create_feature_dict(uk.features, gon.visits);
    let visits_values = Object.values(visitsPlotData);
    let visits_min = get_min(visits_values);
    let visits_max = get_max(visits_values);

    let visits_svg = d3.select('#visits-geo-plot');
    visits_svg.append("g")
        .selectAll("path")
        .data(uk.features)
        .enter()
        .append("path")
        .attr("id", d => `visits-${d.properties.NAME_2}`)
        .attr("fill", d => colour(10 * normalise(visitsPlotData[d.properties.NAME_2], visits_min, visits_max)))
        .attr("stroke", "black")
        .attr("stroke-width", 0.4)
        .attr("d", d3.geoPath(projection))
        .append('title')
        .text(d => `${d.properties.NAME_2}\nVisits: ${!visitsPlotData[d.properties.NAME_2] ? 0 : visitsPlotData[d.properties.NAME_2]}`);

    document.getElementById('visits-geo-plot').append(Legend(d3.scaleSequential([], d3.interpolateGreens), {
        title: 'Visitors',
        width: 250,
    }));

    let countyVisits = document.getElementById('county-visits-list');
    Object.keys(visitsPlotData).forEach(county => {
        let row = document.createElement('tr');
        let countyCol = document.createElement('td');
        countyCol.innerText = county;
        row.appendChild(countyCol);
        let visitsCol = document.createElement('td');
        visitsCol.innerText = visitsPlotData[county];
        row.appendChild(visitsCol);
        countyVisits.append(row);
    });


    // Only update graphs if there are any registrations in the system
    if (gon.registrations && gon.registrations.length > 0) {
        // Gets pageVisits from gon gem - calculated in CalculateMetrics service class
        let vocationRegsCountsChart = HorizontalBarChart(gon.vocationRegistrations, {
            x: d => d.registrations,
            y: d => d.vocation,
            yDomain: d3.groupSort(gon.vocationRegistrations, ([d]) => -d.registrations, d => d.vocation), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Registrations',
            svgElement: document.getElementById('registrations-barchart-plot')
        });

        // Gets timeRegistrations from gon gem - calculated in CalculateMetrics service class
        let regsOverTimeChart = LineChart(gon.timeRegistrations, {
            x: d => d.time,
            y: d => d.registrations,
            z: d => d.vocation,
            yLabel: 'Registrations',
            width,
            height,
            color: 'green',
            svgElement: document.getElementById('registrations-linechart-plot')
        });

        let tierRegsCountsChart = HorizontalBarChart(gon.tierRegistrations, {
            x: d => d.registrations,
            y: d => d.tier,
            yDomain: d3.groupSort(gon.tierRegistrations, ([d]) => -d.registrations, d => d.tier), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Registrations',
            svgElement: document.getElementById('registrations-by-type-barchart-plot')
        });

    } else {
        // Set text of chart areas to indicate that there is no data
        emptyCharts.push(
            document.getElementById('registrations-barchart-plot'),
            document.getElementById('registrations-linechart-plot'),
            document.getElementById('registrations-by-type-barchart-plot'),
        );
    }

    let regsPlotData = create_feature_dict(uk.features, gon.registrations);
    let regs_values = Object.values(regsPlotData);
    let regs_min = get_min(regs_values);
    let regs_max = get_max(regs_values);

    let svg = d3.select('#registrations-geo-plot');
    svg.append("g")
        .selectAll("path")
        .data(uk.features)
        .enter()
        .append("path")
        .attr("id", d => `regs-${d.properties.NAME_2}`)
        .attr("fill", d => colour(10 * normalise(regsPlotData[d.properties.NAME_2], regs_min, regs_max)))
        .attr("stroke", "black")
        .attr("stroke-width", 0.4)
        .attr("d", d3.geoPath(projection))
        .append('title')
        .text(d => `${d.properties.NAME_2}\nRegistrations: ${!regsPlotData[d.properties.NAME_2] ? 0 : regsPlotData[d.properties.NAME_2]}`);

    document.getElementById('registrations-geo-plot').append(Legend(d3.scaleSequential([], d3.interpolateGreens), {
        title: 'Visitors',
        width: 250,
    }));

    let countyRegistration = document.getElementById('county-registrations-list');
    Object.keys(regsPlotData).forEach(county => {
        let row = document.createElement('tr');
        let countyCol = document.createElement('td');
        countyCol.innerText = county;
        row.appendChild(countyCol);
        let regsCol = document.createElement('td');
        regsCol.innerText = regsPlotData[county];
        row.appendChild(regsCol);
        countyRegistration.append(row);
    });

    if (gon.featureShares && gon.featureShares.length > 0) {
        // Get all unique social media types from arrays
        let socials = new Set()
        gon.featureShares.forEach(featureShare => socials.add(featureShare['social']))
        // TODO: Make this more dynamic for if new socials get added
        let colour_map = {'facebook': '#3B5998', 'twitter': '#00ACEE', 'email': '#DB4437'}

        let featureSharesChart = StackedBarChart(gon.featureShares, {
            x: d => d.count,
            y: d => d.feature,
            z: d => d.social,
            xLabel: "No. Shares",
            yDomain: d3.groupSort(gon.featureShares, D => d3.sum(D, d => d.count), d => d.feature), // sort y by x
            zDomain: socials,
            color_map: colour_map,
            colors: d3.schemeSpectral[socials.length],
            width,
            height,
            marginLeft: 80,
            marginRight: 10,
            svgElement: document.getElementById('feature-shares-barchart-plot')
        });
    } else {
        emptyCharts.push(
            document.getElementById('feature-shares-barchart-plot')
        )
    }

    // TODO: Update to views once the feature has been implemented
    if (gon.shares && gon.shares.length > 0) {
        let featureSharesChart = HorizontalBarChart(gon.shares, {
            x: d => d.shares,
            y: d => d.feature,
            yDomain: d3.groupSort(gon.shares, ([d]) => -d.shares, d => d.feature), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 80,
            marginRight: 10,
            xLabel: 'Shares',
            svgElement: document.getElementById('feature-views-barchart-plot')
        });
    } else {
        emptyCharts.push(
            document.getElementById('feature-views-barchart-plot')
        )
    }

    if (gon.visits && gon.visits.length > 0) {
        // Gets sessionFlows from gon gem - calculated in CalculateMetrics service class
        let sessionsList = document.getElementById('sessions-list');
        for (let s of gon.sessionFlows) {
            let b = document.createElement('button');
            b.innerText = 'View Flow';
            b.classList += 'btn btn-success';
            b.onclick = () => {
                let flowList = document.getElementById('flow-list');
                flowList.innerHTML = '';
                for (let i = 0; i < s.flow.length; i++) {
                    let row = document.createElement('tr');
                    let indexCol = document.createElement('td');
                    let pathCol = document.createElement('td');
                    let timeCol = document.createElement('td');
                    indexCol.innerText = (i + 1).toString();
                    pathCol.innerText = s.flow[i].path;
                    timeCol.innerText = `${(Date.parse(s.flow[i].to) - Date.parse(s.flow[i].from)) / 1000}s`;
                    row.append(indexCol);
                    row.append(pathCol);
                    row.append(timeCol);
                    flowList.append(row);
                }
            };
            let row = document.createElement('tr');
            let column1 = document.createElement('td');
            let column2 = document.createElement('td');
            column1.innerText = s.registered;
            row.append(column1);
            column2.append(b);
            row.append(column2);
            sessionsList.append(row);
        }
    } else {
        emptyCharts.push(
            document.getElementById('flow-report-plot'),
        );
    }

    // Add missing data message to appropriate chart areas
    for (let chart of emptyCharts) {
        let svg = d3.select(chart)
            .attr("width", width)
            .attr("height", height)
            .attr("viewBox", [0, 0, width, height])
            .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

        let g = svg.append("g")
            .attr("transform", function (d, i) {
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
});

/** Creates dictionary of counties with counts for the number of
 * points bounded within them
 *
 * @param features UK county features
 * @param data Data to be grouped into county
 * @returns {{}} Dictionary of counties and the number of points bounded within them
 */
function create_feature_dict(features, data) {
    let featureDict = {}
    features.forEach(f => featureDict[f.properties.NAME_2] = 0);
    for (let d of data) {
        if (!d.latitude || !d.longitude) {
            continue;
        }
        for (let f of features) {
            if (d3.geoContains(f, [d.longitude, d.latitude])) {
                featureDict[f.properties.NAME_2] += 1;
                break;
            }
        }
    }
    return featureDict;
}

/** Gets the smallest value in an array
 *
 * @param arr array of numbers
 * @returns {*} smallest value in array
 */
function get_min(arr) {
    return arr.reduce(function (a, b) {
        return Math.min(a, b);
    }, 0);
}

/** Gets the largest value in an array
 *
 * @param arr array of numbers
 * @returns {*} largest value in array
 */
function get_max(arr) {
    return arr.reduce(function (a, b) {
        return Math.max(a, b);
    }, 0);
}

/** Normalises value to be between 0 and 1 based on the
 * minimum and maximum values provided from a dataset
 *
 * @param value value to be normalised
 * @param min minimum value in the set
 * @param max maximum value in the set
 * @returns {number} normalised input
 */
function normalise(value, min, max) {
    return (value - min) / (max - min);
}

/**
 * Groups elements of an array of dicts by a certain key
 * @param arr array of dicts to sort
 * @param key key to sort by
 * @returns {*} dict: key is the specified key's value, value is an array of dicts with the specified key's value
 */
function groupBy(arr, key) {
    return arr.reduce(function (rec_var, x) {
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
    for (let hour = startHour; hour <= endHour; hour += (60 * 60 * 1000)) {
        hoursDict[hour] = [];
    }

    // Sum the number of visits and assign them to groups of hours
    for (let a of arr) {
        let aDate = new Date(Date.parse(a[key])).setMinutes(0, 0, 0);
        hoursDict[aDate].push(a);
    }

    return hoursDict;
}

// Copyright 2021, Observable Inc.
// Released under the ISC license.
// https://observablehq.com/@d3/color-legend
function Legend(color, {
    title,
    tickSize = 6,
    width = 320,
    height = 44 + tickSize,
    marginTop = 18,
    marginRight = 0,
    marginBottom = 16 + tickSize,
    marginLeft = 0,
    ticks = width / 64,
    tickFormat,
    tickValues
} = {}) {

    function ramp(color, n = 256) {
        const canvas = document.createElement("canvas");
        canvas.width = n;
        canvas.height = 1;
        const context = canvas.getContext("2d");
        for (let i = 0; i < n; ++i) {
            context.fillStyle = color(i / (n - 1));
            context.fillRect(i, 0, 1, 1);
        }
        return canvas;
    }

    const svg = d3.create("svg")
        .attr("width", width)
        .attr("height", height)
        .attr("viewBox", [0, 0, width, height])
        .style("overflow", "visible")
        .style("display", "block");

    let tickAdjust = g => g.selectAll(".tick line").attr("y1", marginTop + marginBottom - height);
    let x;

    // Continuous
    if (color.interpolate) {
        const n = Math.min(color.domain().length, color.range().length);

        x = color.copy().rangeRound(d3.quantize(d3.interpolate(marginLeft, width - marginRight), n));

        svg.append("image")
            .attr("x", marginLeft)
            .attr("y", marginTop)
            .attr("width", width - marginLeft - marginRight)
            .attr("height", height - marginTop - marginBottom)
            .attr("preserveAspectRatio", "none")
            .attr("xlink:href", ramp(color.copy().domain(d3.quantize(d3.interpolate(0, 1), n))).toDataURL());
    }

    // Sequential
    else if (color.interpolator) {
        x = Object.assign(color.copy()
                .interpolator(d3.interpolateRound(marginLeft, width - marginRight)),
            {
                range() {
                    return [marginLeft, width - marginRight];
                }
            });

        svg.append("image")
            .attr("x", marginLeft)
            .attr("y", marginTop)
            .attr("width", width - marginLeft - marginRight)
            .attr("height", height - marginTop - marginBottom)
            .attr("preserveAspectRatio", "none")
            .attr("xlink:href", ramp(color.interpolator()).toDataURL());

        // scaleSequentialQuantile doesn’t implement ticks or tickFormat.
        if (!x.ticks) {
            if (tickValues === undefined) {
                const n = Math.round(ticks + 1);
                tickValues = d3.range(n).map(i => d3.quantile(color.domain(), i / (n - 1)));
            }
            if (typeof tickFormat !== "function") {
                tickFormat = d3.format(tickFormat === undefined ? ",f" : tickFormat);
            }
        }
    }

    // Threshold
    else if (color.invertExtent) {
        const thresholds
            = color.thresholds ? color.thresholds() // scaleQuantize
            : color.quantiles ? color.quantiles() // scaleQuantile
                : color.domain(); // scaleThreshold

        const thresholdFormat
            = tickFormat === undefined ? d => d
            : typeof tickFormat === "string" ? d3.format(tickFormat)
                : tickFormat;

        x = d3.scaleLinear()
            .domain([-1, color.range().length - 1])
            .rangeRound([marginLeft, width - marginRight]);

        svg.append("g")
            .selectAll("rect")
            .data(color.range())
            .join("rect")
            .attr("x", (d, i) => x(i - 1))
            .attr("y", marginTop)
            .attr("width", (d, i) => x(i) - x(i - 1))
            .attr("height", height - marginTop - marginBottom)
            .attr("fill", d => d);

        tickValues = d3.range(thresholds.length);
        tickFormat = i => thresholdFormat(thresholds[i], i);
    }

    // Ordinal
    else {
        x = d3.scaleBand()
            .domain(color.domain())
            .rangeRound([marginLeft, width - marginRight]);

        svg.append("g")
            .selectAll("rect")
            .data(color.domain())
            .join("rect")
            .attr("x", x)
            .attr("y", marginTop)
            .attr("width", Math.max(0, x.bandwidth() - 1))
            .attr("height", height - marginTop - marginBottom)
            .attr("fill", color);

        tickAdjust = () => {
        };
    }

    svg.append("g")
        .attr("transform", `translate(0,${height - marginBottom})`)
        .call(d3.axisBottom(x)
            .ticks(ticks, typeof tickFormat === "string" ? tickFormat : undefined)
            .tickFormat(typeof tickFormat === "function" ? tickFormat : undefined)
            .tickSize(tickSize)
            .tickValues(tickValues))
        .call(tickAdjust)
        .call(g => g.select(".domain").remove())
        .call(g => g.append("text")
            .attr("x", marginLeft)
            .attr("y", marginTop + marginBottom - height - 6)
            .attr("fill", "currentColor")
            .attr("text-anchor", "start")
            .attr("font-weight", "bold")
            .attr("class", "title")
            .text(title));

    return svg.node();
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
// https://observablehq.com/@d3/stacked-horizontal-bar-chart
function StackedBarChart(data, {
    x = d => d, // given d in data, returns the (quantitative) x-value
    y = (d, i) => i, // given d in data, returns the (ordinal) y-value
    z = () => 1, // given d in data, returns the (categorical) z-value
    title, // given d in data, returns the title text
    marginTop = 30, // top margin, in pixels
    marginRight = 0, // right margin, in pixels
    marginBottom = 0, // bottom margin, in pixels
    marginLeft = 40, // left margin, in pixels
    width = 640, // outer width, in pixels
    height, // outer height, in pixels
    xType = d3.scaleLinear, // type of x-scale
    xDomain, // [xmin, xmax]
    xRange = [marginLeft, width - marginRight], // [left, right]
    yDomain, // array of y-values
    yRange, // [bottom, top]
    yPadding = 0.1, // amount of y-range to reserve to separate bars
    zDomain, // array of z-values
    offset = d3.stackOffsetDiverging, // stack offset method
    order = d3.stackOrderNone, // stack order method
    xFormat, // a format specifier string for the x-axis
    xLabel, // a label for the x-axis
    color_map, // Predefined map of colours for different stacks on the bar
    svgElement
} = {}) {
    // Compute values.
    const X = d3.map(data, x);
    const Y = d3.map(data, y);
    const Z = d3.map(data, z);

    // Compute default y- and z-domains, and unique them.
    if (yDomain === undefined) yDomain = Y;
    if (zDomain === undefined) zDomain = Z;
    yDomain = new d3.InternSet(yDomain);
    zDomain = new d3.InternSet(zDomain);

    // Omit any data not present in the y- and z-domains.
    const I = d3.range(X.length).filter(i => yDomain.has(Y[i]) && zDomain.has(Z[i]));

    // If the height is not specified, derive it from the y-domain.
    if (height === undefined) height = yDomain.size * 25 + marginTop + marginBottom;
    if (yRange === undefined) yRange = [height - marginBottom, marginTop];

    // Compute a nested array of series where each series is [[x1, x2], [x1, x2],
    // [x1, x2], …] representing the x-extent of each stacked rect. In addition,
    // each tuple has an i (index) property so that we can refer back to the
    // original data point (data[i]). This code assumes that there is only one
    // data point for a given unique y- and z-value.
    const series = d3.stack()
        .keys(zDomain)
        .value(([, I], z) => X[I.get(z)])
        .order(order)
        .offset(offset)
        (d3.rollup(I, ([i]) => i, i => Y[i], i => Z[i]))
        .map(s => s.map(d => Object.assign(d, {i: d.data[1].get(s.key)})));

    // Compute the default y-domain. Note: diverging stacks can be negative.
    if (xDomain === undefined) xDomain = d3.extent(series.flat(2));

    // Construct scales, axes, and formats.
    const xScale = xType(xDomain, xRange);
    const yScale = d3.scaleBand(yDomain, yRange).paddingInner(yPadding);
    const xAxis = d3.axisTop(xScale).ticks(width / 80, xFormat);
    const yAxis = d3.axisLeft(yScale).tickSizeOuter(0);

    // Compute titles.
    if (title === undefined) {
        const formatValue = xScale.tickFormat(100, xFormat);
        title = i => `${Y[i]}\n${Z[i]}\n${formatValue(X[i])}`;
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

    const bar = svg.append("g")
        .selectAll("g")
        .data(series)
        .join("g")
        .attr("fill", ([{i}]) => color_map[Z[i]])
        .selectAll("rect")
        .data(d => d)
        .join("rect")
        .attr("x", ([x1, x2]) => Math.min(xScale(x1), xScale(x2)))
        .attr("y", ({i}) => yScale(Y[i]))
        .attr("width", ([x1, x2]) => Math.abs(xScale(x1) - xScale(x2)))
        .attr("height", yScale.bandwidth());

    if (title) bar.append("title")
        .text(({i}) => title(i));

    svg.append("g")
        .attr("transform", `translate(${xScale(0)},0)`)
        .call(yAxis);

    return Object.assign(svg.node(), color_map);
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
        .call(voronoi ? () => {
        } : g => g.selectAll(".tick line").clone()
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