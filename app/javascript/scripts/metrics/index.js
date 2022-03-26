import * as d3 from 'd3';
import * as graphs from '../graphs/graph_templates';
import * as graph_utils from '../graphs/graph_utils';

const uk = require('./uk-geo.json');

document.addEventListener('DOMContentLoaded', () => {
    // Create charts to display on metrics page
    const width = 1000;
    const height = 500;

    let emptyCharts = [];

    // Only update graphs if there are any site tracking metrics in the system
    if (gon.visits && gon.visits.length > 0) {
        // Gets pageVisits from gon gem - calculated in CalculateMetrics service class
        let pageVisitCountsChart = graphs.HorizontalBarChart(gon.pageVisits, {
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
        let visitsOverTimeChart = graphs.LineChart(gon.timeVisits, {
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

    let visitsPlotData = graph_utils.create_feature_dict(uk.features, gon.visits);
    let visits_values = Object.values(visitsPlotData);
    let visits_min = graph_utils.get_min(visits_values);
    let visits_max = graph_utils.get_max(visits_values);

    let visits_svg = d3.select('#visits-geo-plot');
    visits_svg.append("g")
        .selectAll("path")
        .data(uk.features)
        .enter()
        .append("path")
        .attr("id", d => `visits-${d.properties.NAME_2}`)
        .attr("fill", d => colour(10 * graph_utils.normalise(visitsPlotData[d.properties.NAME_2], visits_min, visits_max)))
        .attr("stroke", "black")
        .attr("stroke-width", 0.4)
        .attr("d", d3.geoPath(projection))
        .append('title')
        .text(d => `${d.properties.NAME_2}\nVisits: ${!visitsPlotData[d.properties.NAME_2] ? 0 : visitsPlotData[d.properties.NAME_2]}`);

    document.getElementById('visits-geo-plot').append(graphs.Legend(d3.scaleSequential([], d3.interpolateGreens), {
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
        let vocationRegsCountsChart = graphs.HorizontalBarChart(gon.vocationRegistrations, {
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
        let regsOverTimeChart = graphs.LineChart(gon.timeRegistrations, {
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
            document.getElementById('registrations-linechart-plot'),
        );
    }

    let regsPlotData = graph_utils.create_feature_dict(uk.features, gon.registrations);
    let regs_values = Object.values(regsPlotData);
    let regs_min = graph_utils.get_min(regs_values);
    let regs_max = graph_utils.get_max(regs_values);

    let svg = d3.select('#registrations-geo-plot');
    svg.append("g")
        .selectAll("path")
        .data(uk.features)
        .enter()
        .append("path")
        .attr("id", d => `regs-${d.properties.NAME_2}`)
        .attr("fill", d => colour(10 * graph_utils.normalise(regsPlotData[d.properties.NAME_2], regs_min, regs_max)))
        .attr("stroke", "black")
        .attr("stroke-width", 0.4)
        .attr("d", d3.geoPath(projection))
        .append('title')
        .text(d => `${d.properties.NAME_2}\nRegistrations: ${!regsPlotData[d.properties.NAME_2] ? 0 : regsPlotData[d.properties.NAME_2]}`);

    document.getElementById('registrations-geo-plot').append(graphs.Legend(d3.scaleSequential([], d3.interpolateGreens), {
        title: 'Registrations',
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

        let featureSharesChart = graphs.StackedBarChart(gon.featureShares, {
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
        let featureSharesChart = graphs.HorizontalBarChart(gon.shares, {
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

    if (gon.products && gon.products.length > 0) {
        // Gets productCategories from gon gem - calculated in CalculateMetrics service class
        let productCategoriesCountChart = graphs.HorizontalBarChart(gon.productCategories, {
            x: d => d.products,
            y: d => d.category,
            yDomain: d3.groupSort(gon.productCategories, ([d]) => -d.products, d => d.category), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Products',
            svgElement: document.getElementById('products-barchart-plot')
        });

        // Gets timeProducts from gon gem - calculated in CalculateMetrics service class
        let productsOverTimeChart = graphs.LineChart(gon.timeProducts, {
            x: d => d.time,
            y: d => d.products,
            yLabel: 'Products',
            width,
            height,
            color: 'green',
            svgElement: document.getElementById('products-linechart-plot'),
        });
    } else {
        // Set text of chart areas to indicate that there is no data
        emptyCharts.push(
            document.getElementById('products-barchart-plot'),
            document.getElementById('products-linechart-plot'));
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