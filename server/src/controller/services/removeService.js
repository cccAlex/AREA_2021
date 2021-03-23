const User = require('../../models/User');
const joi = require('../../plugins/joi');

const removeServiceSchema = joi.object({
    name: joi.string().required(),
});

const removeService = async (req, res) => {
    const { error } = removeServiceSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { name } = req.body;
    User.updateOne({ _id: res.locals.user._id }, { $pull: { services: { name } } })
        .exec()
        .then(() => res.send({ status: true, data: 'Ok' }))
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = removeService;
