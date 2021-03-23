const jwt = require('jsonwebtoken');
const { google } = require('googleapis');

const googleOauth2Client = new google.auth.OAuth2(
    process.env.GOOGLE_CLIENT_ID,
    process.env.GOOGLE_CLIENT_SECRET,
    process.env.GOOGLE_CLIENT_REDIRECT_URI
);

const sendToken = (res, user, redirectURL = undefined) => {
    const token = jwt.sign({ _id: user._id }, process.env.JWT_SECRET_KEY, { expiresIn: process.env.JWT_DURATION || '1h' });

    res.send({ status: true, data: { ...user._doc, password: undefined, oauth2: undefined, token, redirectURL } });
};

exports.sendToken = sendToken;
exports.googleOauth2Client = googleOauth2Client;