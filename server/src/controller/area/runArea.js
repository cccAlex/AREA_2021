const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { startArea } = require('./utils');

const runAreaSchema = joi.object({
    areaID: joi.objectId().required(),
});

const runArea = (req, res) => {
    const { error } = runAreaSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { areaID } = req.body;
    User.updateOne({ "area._id": areaID }, { "$set": { "area.$.active": true } })
        .exec()
        .then((result) => {
            if (!result.n) throw new Error('Area not found.');

            startArea(areaID);
            res.send({ status: true, data: 'Area started !' });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = runArea;