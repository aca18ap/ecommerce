import * as d3 from 'd3';
import * as graphs from '../graphs/graph_templates';
import * as d3_graph_utils from '../graphs/d3_graph_utils';

document.addEventListener('DOMContentLoaded', () => {
    const width = 1000;
    const height = 500;

    let emptyCharts = [];

    console.log(gon.timeCO2PerPurchase);
    console.log(gon.timeCO2Saved);

    if (gon.timeCO2PerPurchase && Object.keys(gon.timeCO2PerPurchase).length > 0) {
        graphs.LineChart(gon.timeCO2PerPurchase, {
            x: d => d.time,
            y: d => d.value,
            width,
            height,
            color: 'green',
            marginTop: 30,
            marginLeft: 40,
            marginRight: 20,
            xType: d3.scaleTime,
            yLabel: 'CO2/Purchase',
            svgElement: document.getElementById('co2-purchased-graph'),
        });
    } else {
        emptyCharts.push(document.getElementById('co2-purchased-graph'));
    }

    if (gon.timeTotalCO2 && Object.keys(gon.timeTotalCO2).length > 0) {
        graphs.LineChart(gon.timeTotalCO2, {
            x: d => d.time,
            y: d => d.value,
            width,
            height,
            color: 'green',
            marginTop: 30,
            marginLeft: 40,
            marginRight: 20,
            xType: d3.scaleTime,
            yLabel: 'Total CO2',
            svgElement: document.getElementById('total-co2-graph'),
        });
    } else {
        emptyCharts.push(document.getElementById('total-co2-graph'));
    }

    if (gon.timeCO2Saved && Object.keys(gon.timeCO2Saved).length > 0) {
        graphs.LineChart(gon.timeCO2Saved, {
            x: d => d.time,
            y: d => d.value,
            width,
            height,
            color: 'green',
            marginTop: 30,
            marginLeft: 40,
            marginRight: 20,
            xType: d3.scaleTime,
            yLabel: 'CO2 Saved',
            svgElement: document.getElementById('co2-saved-graph'),
        });
    } else {
        emptyCharts.push(document.getElementById('co2-saved-graph'));
    }

    if (gon.timeCO2PerPound && Object.keys(gon.timeCO2PerPound).length > 0) {
        graphs.LineChart(gon.timeCO2PerPound, {
            x: d => d.time,
            y: d => d.value,
            width,
            height,
            color: 'green',
            marginTop: 30,
            marginLeft: 40,
            marginRight: 20,
            xType: d3.scaleTime,
            yLabel: 'CO2/£',
            svgElement: document.getElementById('co2-pound-graph'),
        });
    } else {
        emptyCharts.push(document.getElementById('co2-pound-graph'));
    }

    if (gon.timeProductsTotal && Object.keys(gon.timeProductsTotal).length > 0) {
        graphs.LineChart(gon.timeProductsTotal, {
            x: d => d.time,
            y: d => d.value,
            width,
            height,
            color: 'green',
            marginTop: 30,
            marginLeft: 40,
            marginRight: 20,
            xType: d3.scaleTime,
            yLabel: 'Products Added',
            svgElement: document.getElementById('products-added-graph'),
        });
    } else {
        emptyCharts.push(document.getElementById('products-added-graph'));
    }

    // Add missing data message to appropriate chart areas
    for (let chart of emptyCharts) d3_graph_utils.insert_empty_chart_message(chart, width, height);
});

$('.delete_product').bind('ajax:success', function() {
    let productId = $(this).attr('data-deleted-product-id');
    $(`#product-${productId}-partial`).fadeOut();
});