const joi = require('joi');

joi.objectId = require('joi-objectid')(joi);

module.exports = joi;