const Area = require('../../models/Area');
const User = require('../../models/User');

const joi = require('../../plugins/joi');
const { pullArea, endArea } = require('./utils');

const removeAreaSchema = joi.object({
    areaID: joi.objectId().required(),
});

const addArea = (req, res) => {
    const { error } = removeAreaSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { areaID } = req.body;
    User.updateOne({ _id: res.locals.user._id }, { $pull: { area: { _id: areaID } } })
        .exec()
        .then(async ({ nModified }) => {
            if (nModified) {
                const { ok } = await Area.deleteMany({ areaID }).exec();

                if (ok) {
                    endArea(areaID);
                    pullArea(areaID);
                }
            }
            res.send({ status: true, data: 'Ok' });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = addArea;