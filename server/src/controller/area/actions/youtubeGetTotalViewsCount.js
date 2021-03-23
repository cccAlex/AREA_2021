const axios = require('axios');
const Area = require('../../../models/Area');


const areaName = 'youtubeGetTotalViewsCount';

const youtubeGetTotalViewsCount = async (areaID, { serviceParams, params }) => {
    try {
        const area = await Area.findOne({ name: areaName, areaID }).exec();
        if (!area) {
            await new Area({ name: areaName, areaID, params: JSON.stringify(false) }).save();
            return { status: false, data: null };
        }

        const { data } = await axios.get('https://youtube.googleapis.com/youtube/v3/channels?part=statistics&mine=true', {
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${serviceParams.tokens.access_token}` }
        });
        if (data.items) {
            if (parseInt(data.items[0].statistics.viewCount) >= parseInt(params.views_goal) && !JSON.parse(area.params)) {
                await Area.updateOne({ name: areaName, areaID }, { params: JSON.stringify(true) }).exec();
                return { status: true, data: '| Youtube | You reached your total views goal (' + params.views_goal + '). Current total views count: ' + data.items[0].statistics.viewCount + ' views!'};
            }
        }
        return { status: false, data: null };
    } catch(err) {
        console.log(err.message);
        return { status: false, data: null };
    }
};

module.exports = youtubeGetTotalViewsCount;