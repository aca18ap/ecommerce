import * as d3 from 'd3';
import * as graphs from '../graphs/graph_templates';
import * as d3_graph_utils from '../graphs/d3_graph_utils';

document.addEventListener('DOMContentLoaded', () => {
    const width = 1000;
    const height = 500;

    let emptyCharts = [];

    if (gon.timeAffiliateViews && Object.keys(gon.timeAffiliateViews).length > 0) {
        graphs.LineChart(gon.timeAffiliateViews, {
            x: d => d.time,
            y: d => d.value,
            width,
            height,
            color: 'green',
            marginTop: 30,
            marginLeft: 40,
            marginRight: 20,
            xType: d3.scaleTime,
            yLabel: 'Product Views',
            svgElement: document.getElementById('total-product-views-graph'),
        });
    } else {
        emptyCharts.push(document.getElementById('total-product-views-graph'));
    }

    if (gon.viewsByProduct && Object.keys(gon.viewsByProduct).length > 0) {
        graphs.HorizontalBarChart(gon.viewsByProduct, {
            x: d => d.count,
            y: d => d.name,
            yDomain: d3.groupSort(gon.viewsByProduct, ([d]) => -d.count, d => d.name), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Views By Product',
            svgElement: document.getElementById('product-views-graph')
        });
    } else {
        emptyCharts.push(document.getElementById('product-views-graph'));
    }

    if (gon.viewsByCategory && Object.keys(gon.viewsByCategory).length > 0) {
        graphs.HorizontalBarChart(gon.viewsByCategory, {
            x: d => d.count,
            y: d => d.category,
            yDomain: d3.groupSort(gon.viewsByCategory, ([d]) => -d.count, d => d.category), // sort by descending frequency
            width,
            height,
            color: 'green',
            marginLeft: 70,
            marginRight: 10,
            xLabel: 'Views By Category',
            svgElement: document.getElementById('category-views-graph')
        });
    } else {
        emptyCharts.push(document.getElementById('category-views-graph'));
    }

    // Add missing data message to appropriate chart areas
    for (let chart of emptyCharts) d3_graph_utils.insert_empty_chart_message(chart, width, height);
});

$('.delete_product').bind('ajax:success', function() {
    let productId = $(this).attr('data-deleted-product-id');
    $(`#product-${productId}-partial`).fadeOut();
});