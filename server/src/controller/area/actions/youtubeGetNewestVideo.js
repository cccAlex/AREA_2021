const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'youtubeGetNewestVideo';

const youtubeGetNewestVideo = async (areaID, { serviceParams, params }) => {
    try {
        const area = await Area.findOne({ name: areaName, areaID }).exec();

        const { data : { items } } = await axios.get('https://youtube.googleapis.com/youtube/v3/channels?part=contentDetails&id=' + params.channelURL, {
            headers: { 'Authorization': `Bearer ${serviceParams.tokens.access_token}` }
        });
        if (!items) return { status: false, data: null };

        const { data } = await axios.get('https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=1&playlistId=' + items[0].contentDetails.relatedPlaylists.uploads, {
            headers: { 'Authorization': `Bearer ${serviceParams.tokens.access_token}` }
        });
        if (!data.items) return { status: false, data: null };

        if (!area) {
            await new Area({ name: areaName, areaID, params: JSON.stringify(data.items[0].snippet)}).save();
            return { status: false, data: null };
        }
        const { channelTitle, title, publishedAt , resourceId : {videoId} } = data.items[0].snippet
        if (publishedAt != JSON.parse(area.params).publishedAt) {
            await Area.updateOne({ name: areaName, areaID }, { params: JSON.stringify(data.items[0].snippet) }).exec();
            return { status: true, data: '| Youtube | ' + channelTitle + ' posted new video : ' + title + ' on ' + publishedAt + '. https://www.youtube.com/watch?v=' + videoId }
        }
        return { status: false, data: null };
    } catch (err) {
        console.log(err.message);
        return { status: false, data: null };
    }
}
module.exports = youtubeGetNewestVideo;