const bcrypt = require('bcrypt');

const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { sendToken } = require('./utils');

const signInSchema = joi.object({
    username: joi.string().required(),
    password: joi.string(),
});

const signIn = (req, res) => {
    const { error } = signInSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { username, password } = req.body;
    User.findOne({ username })
        .exec()
        .then(async (user) => {
            if (!user || user.oauth2) throw new Error(!user ? 'User does not exist.' : 'Invalid credentials.');

            const isValid = await bcrypt.compare(password, user.password);
            if (!isValid) throw new Error('Invalid credentials.');

            sendToken(res, user);
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = signIn;