const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { endArea } = require('./utils');

const stopAreaSchema = joi.object({
    areaID: joi.objectId().required(),
});

const stopArea = (req, res) => {
    const { error } = stopAreaSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { areaID } = req.body;
    User.updateOne({ "area._id": areaID }, { "$set": { "area.$.active": false } })
        .exec()
        .then((result) => {
            if (!result.n) throw new Error('Area not found.');

            endArea(areaID);
            res.send({ status: true, data: 'Area stopped !' });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = stopArea;