/** Gets the smallest value in an array
 *
 * @param arr array of numbers
 * @returns {*} smallest value in array
 */
export function get_min(arr) {
    return Math.min.apply(Math, arr)
}

/** Gets the largest value in an array
 *
 * @param arr array of numbers
 * @returns {*} largest value in array
 */
export function get_max(arr) {
    return Math.max.apply(Math, arr)
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