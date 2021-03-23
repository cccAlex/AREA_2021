const axios = require('axios');

const spotifyAddToPlaylist = async (areaID, { serviceParams, params }, data) => {
    await axios.post('https://api.spotify.com/v1/playlists/' + params.playlistID + '/tracks', {
        uris: data.map(({uri}) => uri)
    }, { headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${serviceParams.access_token}` } });
}

module.exports = spotifyAddToPlaylist;