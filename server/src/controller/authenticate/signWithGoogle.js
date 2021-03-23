const axios = require('axios');

const { googleOauth2Client } = require('./utils');
const joi = require('../../plugins/joi');
const User = require('../../models/User');
const { sendToken } = require('./utils');
const sendConfirmationEmail = require('../../utils/sendConfirmationEmail');
const getUsernameFromEmail = require('../../utils/getUsernameFromEmail');


const googleEmailScope = 'https://www.googleapis.com/oauth2/v2/userinfo';

const signWithGoogleSchema = joi.object({
    state: joi.string().required(),
    code: joi.string().required(),
});

const signWithGoogle = (req, res) => {
    const { error } = signWithGoogleSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    googleOauth2Client.getToken(req.body.code)
        .then(async ({ tokens }) => {
            const { status, data: { email } } = await axios.get( googleEmailScope, { headers: { authorization: `Bearer ${tokens.access_token}` } })
            if (status !== 200) throw new Error('Invalid credentials');

            const user = await User.findOne({ email }).exec();
            if (user) return user.oauth2 ? sendToken(res, user, req.body.state) :
                res.send({ status: false, data: 'Invalid credentials' });

            const username = await getUsernameFromEmail(email);
            const newUser = await new User({ email, username, confirmed: false, oauth2: true }).save();

            await sendConfirmationEmail(newUser);
            sendToken(res, newUser, req.body.state);
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = signWithGoogle;
