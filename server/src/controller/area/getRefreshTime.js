const { cronExpressionsArray } = require("./utils");

const getRefreshTime = (req, res) => res.send({ status: true, data: cronExpressionsArray });

module.exports = getRefreshTime;