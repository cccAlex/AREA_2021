const axios = require('axios');
const queryString = require('query-string');

const joi = require('../../plugins/joi');
const { addService } = require('./utils');

const client_id = process.env.SPOTIFY_CLIENT_ID;
const redirect_uri = process.env.SPOTIFY_REDIRECT_URI;

const authorizeParams = queryString.stringify({
    response_type: 'code',
    client_id,
    redirect_uri,
    scope: 'user-read-private user-read-email user-read-playback-position playlist-read-private user-library-read user-library-modify user-top-read playlist-read-collaborative playlist-modify-public playlist-modify-private ugc-image-upload user-follow-read user-follow-modify user-read-playback-state user-modify-playback-state user-read-currently-playing user-read-recently-played',
});
const spotifyAuthorizeURL = `https://accounts.spotify.com/authorize?${authorizeParams}`;

const spotifyTokenURL = 'https://accounts.spotify.com/api/token';

const urlEncodedHeaders = { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' };

const spotifySignInBody = {
    grant_type: 'authorization_code',
    client_id,
    client_secret: process.env.SPOTIFY_CLIENT_SECRET,
    redirect_uri,
};

const spotifySignInSchema = joi.object({
    code: joi.string().required(),
    state: joi.string()
});

const spotifyServiceName = 'Spotify';

const getSpotifyAuthURL = (req, res) => res.send({ status: true, data: { url: spotifyAuthorizeURL } });

const getSpotifyData = async ({ access_token }) => {
    const { data: { email, display_name } } = await axios.get('https://api.spotify.com/v1/me',
        { headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${access_token}` } }
    );

    return { email, display_name };
};

const spotifySignIn = (req, res) => {
    const { error } = spotifySignInSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { code } = req.body;
    axios.post(spotifyTokenURL, queryString.stringify({ ...spotifySignInBody, code }), urlEncodedHeaders)
        .then(async ({ data }) => {
            const userData = await getSpotifyData(data);
            await addService(res.locals.user._id, spotifyServiceName, { ...data, ...userData });
            res.send({ status: true, data });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

exports.getSpotifyAuthURL = getSpotifyAuthURL;
exports.spotifySignIn = spotifySignIn;