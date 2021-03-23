const joi = require('../../plugins/joi');
const { findUserById } = require('./utils');

const userSchema = joi.object({
    _id: joi.objectId().required(),
});

const getUser = (req, res) => {
    const findUser = (_id) => findUserById(_id)
        .then((user) => {
            if (!user) throw new Error('User not found.');

            res.send({ status: true, data: user._doc });
        })
        .catch((err) => res.send({ status: false, data: err.message }));

    if (!req.query._id) return findUser(res.locals.user._id);

    const { error } = userSchema.validate(req.query);
    if (error) return res.send({ status: false, data: 'Invalid parameter' });

    findUser(req.query._id);
};

module.exports = getUser;