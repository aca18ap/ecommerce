const { environment } = require('@rails/webpacker')
const aliasConfig = {
    'd3': 'd3/dist/d3.js'
};

environment.config.set('resolve.alias', aliasConfig);


module.exports = environment
