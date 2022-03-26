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

/** Gets the smallest value in an array
 *
 * @param arr array of numbers
 * @returns {*} smallest value in array
 */
export function get_min(arr) {
    return arr.reduce(function (a, b) {
        return Math.min(a, b);
    }, 0);
}

/** Gets the largest value in an array
 *
 * @param arr array of numbers
 * @returns {*} largest value in array
 */
export function get_max(arr) {
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
export function normalise(value, min, max) {
    return (value - min) / (max - min);
}

/**
 * Groups elements of an array of dicts by a certain key
 * @param arr array of dicts to sort
 * @param key key to sort by
 * @returns {*} dict: key is the specified key's value, value is an array of dicts with the specified key's value
 */
export function groupBy(arr, key) {
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
export function groupByHour(arr, key, startTime) {
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