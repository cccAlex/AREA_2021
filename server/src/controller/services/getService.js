const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { decryptParams } = require('../../utils/cryptParams');

const getServiceSchema = joi.object({
    name: joi.string().required(),
});

const getService = (req, res) => {
    const { error } = getServiceSchema.validate(req.query);
    if (error) return res.send({ status: false, data: error.message });

    const { name } = req.query;
    User.findById(res.locals.user._id, 'services')
        .exec()
        .then(user => {
            if (!user) throw new Error('User not found.');

            for (const service of user.services)
                if (service.name === name)
                    return res.send({
                        status: true,
                        data: {
                            name: service.name,
                            params: decryptParams(service.params)
                        }
                    })
            res.send({ status: true, data: null });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = getService;