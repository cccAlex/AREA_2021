const axios = require('axios');

const youtubeLikeVideo = async (areaID, { serviceParams }, data) => {
    let url = data.match(/(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$])/igm)
    const videoID = url[0].replace('https://www.youtube.com/watch?v=', '')

    await axios.post('https://youtube.googleapis.com/youtube/v3/videos/rate?id=' + videoID + '&rating=like', {}, {
        headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${serviceParams.tokens.access_token}` }
    });
}

module.exports = youtubeLikeVideo;