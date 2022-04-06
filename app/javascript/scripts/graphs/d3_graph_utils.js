import * as d3 from "d3";

/** Creates dictionary of counties with counts for the number of
 * points bounded within them
 *
 * @param features UK county features
 * @param data Data to be grouped into county
 * @returns {{}} Dictionary of counties and the number of points bounded within them
 */
export function create_feature_dict(features, data) {
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

/** Inserts missing data message into an SVG, passed as a DOM object
 *
 * @param chart Array of DOM objects for SVGs to insert missing data text for
 * @param width Width of graph
 * @param height Height of graph
 */
export function insert_empty_chart_message(chart, width, height) {
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
