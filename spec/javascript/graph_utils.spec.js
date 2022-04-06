import * as graph_utils from '../../app/javascript/scripts/graphs/graph_utils';

test('.get_min returns the smallest value in an array', () => {
    let data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    expect(graph_utils.get_min(data)).toEqual(1);
});

test('.get_max returns the largest value in an array', () => {
    let data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    expect(graph_utils.get_max(data)).toEqual(10);
});

test('.normalise returns 1 if it is equal to the max', () => {
    let val = 10;
    let max = 10;
    let min = 0;
    expect(graph_utils.normalise(val, min, max)).toEqual(1);
});

test('.normalise returns 0 if it is equal to the min', () => {
    let val = 0;
    let max = 10;
    let min = 0;
    expect(graph_utils.normalise(val, min, max)).toEqual(0);
});

test('.groupBy returns a hashmap of values, grouped by a specified key, from an array of hashes', () => {
    let test_arr = [
        {'test_key': 1, 'another_key': 1},
        {'test_key': 1, 'another_key': 2},
        {'test_key': 2, 'another_key': 3},
        {'test_key': 3, 'another_key': 4},
    ];
    expect(graph_utils.groupBy(test_arr, 'test_key')).toEqual({
        1: [{'test_key': 1, 'another_key': 1},
            {'test_key': 1, 'another_key': 2}],
        2: [{'test_key': 2, 'another_key': 3}],
        3: [{'test_key': 3, 'another_key': 4}]
    })
});