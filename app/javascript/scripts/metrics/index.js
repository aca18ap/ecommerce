import * as d3 from 'd3';
import * as graphs from '../graphs/graph_templates';
import * as graph_utils from '../graphs/graph_utils';
import * as d3_graph_utils from '../graphs/d3_graph_utils';

const uk = require('./uk-geo.json');

document.addEventListener('DOMContentLoaded', () => {
    // Create charts to display on metrics page
    const width = 1000;
    const height = 500;

    let projection = d3.geoAlbers()
        .center([0, 55.4])
        .rotate([4.4, 0])
        .parallels([50, 60])
        .scale(4000)
        .translate([width / 5, (2.4 * height) / 3])

    const colour = d3.scaleSequential([1, 10], d3.interpolateGreens);
    colour.unknown('#fff');

    let visitsPlotData = d3_graph_utils.create_feature_dict(uk.features, gon.visits);
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

    let regsPlotData = d3_graph_utils.create_feature_dict(uk.features, gon.registrations);
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

    if (gon.sessionFlows && gon.sessionFlows.length > 0) {
        let sessionsList = document.getElementById('sessions-list');
        for (let s of gon.sessionFlows) {
            let b = document.createElement('button');
            b.innerText = 'View Flow';
            b.classList += 'btn btn-success';
            b.onclick = () => {

            }
    }

    // if (gon.visits && gon.visits.length > 0) {
    //     // Gets sessionFlows from gon gem - calculated in CalculateMetrics service class
    //     let sessionsList = document.getElementById('sessions-list');
    //     for (let s of gon.sessionFlows) {
    //         let b = document.createElement('button');
    //         b.innerText = 'View Flow';
    //         b.classList += 'btn btn-success';
    //         b.onclick = () => {
    //             let flowList = document.getElementById('flow-list');
    //             flowList.innerHTML = '';
    //             for (let i = 0; i < s.flow.length; i++) {
    //                 let row = document.createElement('tr');
    //                 let indexCol = document.createElement('td');
    //                 let pathCol = document.createElement('td');
    //                 let timeCol = document.createElement('td');
    //                 indexCol.innerText = (i + 1).toString();
    //                 pathCol.innerText = s.flow[i].path;
    //                 timeCol.innerText = `${(Date.parse(s.flow[i].to) - Date.parse(s.flow[i].from)) / 1000}s`;
    //                 row.append(indexCol);
    //                 row.append(pathCol);
    //                 row.append(timeCol);
    //                 flowList.append(row);
    //             }
    //         };
    //         let row = document.createElement('tr');
    //         let column1 = document.createElement('td');
    //         let column2 = document.createElement('td');
    //         column1.innerText = s.registered;
    //         row.append(column1);
    //         column2.append(b);
    //         row.append(column2);
    //         sessionsList.append(row);
    //     }
    // } else {
    //     emptyCharts.push(
    //         document.getElementById('flow-report-plot'),
    //     );
    }
});