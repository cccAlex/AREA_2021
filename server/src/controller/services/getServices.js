const User = require('../../models/User');
const { decryptParams } = require('../../utils/cryptParams');

const getServices = (req, res) => {
    User.findById(res.locals.user._id, 'services')
        .exec()
        .then(async (user) => {
            if (!user) throw new Error('User not found.');

            const services = [];
            for (const { name, params } of user.services)
                services.push({ name, params: decryptParams(params) });
            res.send({ status: true, data: services });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = getServices;