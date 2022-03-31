import * as d3 from 'd3';
import * as graphs from '../graphs/graph_templates';
import * as graph_utils from '../graphs/graph_utils';
import {insert_empty_chart_message} from "../graphs/graph_utils";

document.addEventListener('DOMContentLoaded', () => {
    const width = 1000;
    const height = 500;

    let emptyCharts = [];

    console.log(gon.timeCO2PerPound)
    console.log(gon.timeCO2PerPurchase)

    // Add missing data message to appropriate chart areas
    for (let chart of emptyCharts) insert_empty_chart_message(chart, width, height);
})