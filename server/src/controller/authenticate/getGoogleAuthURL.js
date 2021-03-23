const { googleOauth2Client } = require('./utils');

const googleAuthScopes = [ 'https://www.googleapis.com/auth/userinfo.email' ];

const getGoogleAuthURL = (req, res) => {
    res.send({
    status: true,
    data: {
        url: googleOauth2Client.generateAuthUrl({
            access_type: 'offline',
            scope: googleAuthScopes,
            state: req.query.redirectURL,
        }),
    },
})
};

module.exports = getGoogleAuthURL;