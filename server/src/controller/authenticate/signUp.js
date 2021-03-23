const bcrypt = require('bcrypt');

const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { sendToken } = require('./utils');
const sendConfirmationEmail = require('../../utils/sendConfirmationEmail');

const signUpSchema = joi.object({
    email: joi.string().email().required(),
    username: joi.string().required(),
    password: joi.string().required(),
});

const signUp = (req, res) => {
    const { error } = signUpSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { email, username, password } = req.body;
    User.exists({ $or: [ { email }, { username } ] })
        .then(async (userExists) => {
            if (userExists) throw new Error('User already exists.')

            const hash = await bcrypt.hash(password, 10);
            const user = await new User({ email, username, confirmed: false, password: hash }).save();
            // send confirmation mail

            await sendConfirmationEmail(user);
            sendToken(res, user);
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};


module.exports = signUp;