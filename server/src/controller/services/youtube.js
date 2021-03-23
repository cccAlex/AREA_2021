const axios = require('axios');
const {google} = require('googleapis');
const joi = require('../../plugins/joi');
const { addService } = require('./utils');

const client_id = process.env.GOOGLE_GMAIL_CLIENT_ID;
const client_secret = process.env.GOOGLE_GMAIL_CLIENT_SECRET;
const redirect_uri = process.env.GOOGLE_YOUTUBE_REDIRECT_URI;

const SCOPES = ['https://www.googleapis.com/auth/youtube'];


const oAuth2Client = new google.auth.OAuth2(
    client_id, client_secret, redirect_uri);

const getYoutubeAuthURL = (req, res) => res.send({ status: true, data: { url: getAuthUrl(oAuth2Client) } });

function getAuthUrl(oAuth2Client) {
  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  return authUrl;
}

const YoutubeSignInSchema = joi.object({
    code: joi.string().required(),
    state: joi.string()
});

const getYoutubeData = async (access_token) => {
    try {
        const { data } = await axios.get('https://youtube.googleapis.com/youtube/v3/channels?part=snippet&mine=true',
            { headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${access_token}` } }
        );
        const { title } = data.items[0].snippet
        return {display_name:title} ;
    } catch (err) {
        console.log(err)
    }
};

const youtubeSignIn = (req, res) => {
    const { error } = YoutubeSignInSchema.validate(req.body);
    if (error) {
        return res.send({ status: false, data: error.message });
    }

    oAuth2Client.getToken(req.body.code)
        .then(async (data) => {
            const userData = await getYoutubeData(data.tokens.access_token);
            await addService(res.locals.user._id, "Youtube", {...data, ...userData})
            res.send({status: true, data})
        })
        .catch((err) => {
            res.send({ status: false, data: err.message })
        });
};


exports.getYoutubeAuthURL = getYoutubeAuthURL;
exports.youtubeSignIn = youtubeSignIn;