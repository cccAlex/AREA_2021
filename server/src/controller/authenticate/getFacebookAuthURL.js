const getFacebookAuthURL = (req, res) => res.send({
    status: true,
    data: {
        url: process.env.FACEBOOK_OAUTH_URI +
        '&client_id=' + process.env.FACEBOOK_OAUTH_CLIENT_ID +
        '&redirect_uri=' + process.env.FACEBOOK_OAUTH_REDIRECT_URI
    },
});

module.exports = getFacebookAuthURL;