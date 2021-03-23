const axios = require('axios');

const User = require('../../models/User');
const { sendToken } = require('./utils');
const getUsernameFromEmail = require('../../utils/getUsernameFromEmail');

const signWithFacebook = (req, res) => {
    const { access_token } = req.body;
    if (!access_token) return res.send({ status: false, data: 'access_token must be a valid string' });

    axios.get(`https://graph.facebook.com/v9.0/me?fields=id,name,email&access_token=${access_token}`)
        .then(async ({data, error}) => {
            if (error) return res.send({ status: false, data: error.code + error.type });
            const facebook_email = data.name.replace(' ', '') + '@' + data.name.replace(' ', '') + '.fb';
            const user = await User.findOne({ email:facebook_email }).exec();

            if (user) return user.oauth2 ? sendToken(res, user, req.body.state) :
                res.send({ status: false, data: 'Invalid credentials' });

            const username = await getUsernameFromEmail(facebook_email);
            const newUser = await new User({ email:facebook_email, username, confirmed: true, oauth2: true }).save();

            sendToken(res, newUser, req.body.state);
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = signWithFacebook;