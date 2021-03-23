const {google} = require('googleapis');
const joi = require('../../plugins/joi');
const { addService } = require('./utils');

const client_id = process.env.GOOGLE_GMAIL_CLIENT_ID;
const client_secret = process.env.GOOGLE_GMAIL_CLIENT_SECRET;
const redirect_uri = process.env.GOOGLE_DRIVE_REDIRECT_URI;

const SCOPES = ['https://www.googleapis.com/auth/drive', ];


const oAuth2Client = new google.auth.OAuth2(
    client_id, client_secret, redirect_uri);

const getGoogleDriveAuthURL = (req, res) => res.send({ status: true, data: { url: getAuthUrl(oAuth2Client) } });

function getAuthUrl(oAuth2Client) {
  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  return authUrl;
}

const GoogleDriveSignInSchema = joi.object({
    code: joi.string().required(),
    state: joi.string()
});

const googleDriveSignIn = (req, res) => {
    const { error } = GoogleDriveSignInSchema.validate(req.body);
    if (error) {
        return res.send({ status: false, data: error.message });
    }

    oAuth2Client.getToken(req.body.code)
        .then(async (data) => {
            await addService(res.locals.user._id, "Google Drive", data)
            res.send({status: true, data})
        })
        .catch((err) => {
            res.send({ status: false, data: err.message })
        });
};


exports.getGoogleDriveAuthURL = getGoogleDriveAuthURL;
exports.googleDriveSignIn = googleDriveSignIn;