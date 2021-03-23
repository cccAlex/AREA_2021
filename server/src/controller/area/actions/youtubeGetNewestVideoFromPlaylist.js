const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'youtubeGetNewestVideoFromPlaylist';

const youtubeGetNewestVideoFromPlaylist = async (areaID, { serviceParams, params }) => {
    try {
        const area = await Area.findOne({ name: areaName, areaID }).exec();

        const { data } = await axios.get('https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=1&playlistId=' + params.playlistID, {
            headers: { 'Authorization': `Bearer ${serviceParams.tokens.access_token}` }
        });
        if (!data.items) return { status: false, data: null };

        const playlist = await axios.get('https://www.googleapis.com/youtube/v3/playlists?part=snippet&id=' + params.playlistID, {
            headers: { 'Authorization': `Bearer ${serviceParams.tokens.access_token}` }
        });
        const playlistName = playlist.data.items[0].snippet.title;

        if (!area) {
            await new Area({ name: areaName, areaID, params: JSON.stringify(data.items[0].snippet)}).save();
            return { status: false, data: null };
        }
        const { channelTitle, title, publishedAt , resourceId : {videoId} } = data.items[0].snippet
        if (publishedAt != JSON.parse(area.params).publishedAt) {
            await Area.updateOne({ name: areaName, areaID }, { params: JSON.stringify(data.items[0].snippet) }).exec();
            return { status: true, data: '| Youtube | New video in playlist [' + playlistName + '] ' + channelTitle + ' posted video : ' + title + ' on ' + publishedAt + '. https://www.youtube.com/watch?v=' + videoId }
        }
        return { status: false, data: null };
    } catch (err) {
        console.log(err.message);
        return { status: false, data: null };
    }
}
module.exports = youtubeGetNewestVideoFromPlaylist;