const jwt = require('jsonwebtoken');

const joi = require('../../plugins/joi');
const User = require('../../models/User');
const { findUserById } = require('../user/utils');

const confirmUserSchema = joi.object({
    code: joi.string().required(),
});

const secretKey = process.env.JWT_SECRET_KEY || 'my_ultimate_secret_key';

const confirmUser = (req, res) => {
    const { error } = confirmUserSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { code } = req.body;
    jwt.verify(code, secretKey, (err, { user: {_id} }) => {
        if (err) return res.send({ status: false, data: 'Invalid token' });

        User.updateOne({ _id }, { confirmed: true })
            .exec()
            .then(async (result) => {
                if (!result.n) return res.send({ status: false, data: 'User not found.' });

                const user = await findUserById(_id);
                res.send({ status: true, data: user._doc });
            })
            .catch((err) => res.send({ status: false, data: err.message }));
    });
};

module.exports = confirmUser;