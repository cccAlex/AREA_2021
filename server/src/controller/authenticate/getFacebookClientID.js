const getFacebookClientID = (req, res) => {
    res.send({ status: true, data: { clientID: process.env.FACEBOOK_API_CLIENT_ID } })
};

module.exports = getFacebookClientID;