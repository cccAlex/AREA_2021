const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'youtubeGetSubscribersCount';
const youtubeGetSubscribersCount = async (areaID, { serviceParams, params }) => {
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
            if (parseInt(data.items[0].statistics.subscriberCount) >= parseInt(params.subscriber_goal) && !JSON.parse(area.params)) {
                await Area.updateOne({ name: areaName, areaID }, { params: JSON.stringify(true) }).exec();
                return { status: true, data: '| Youtube | You reached your subscribers goal (' + params.subscriber_goal + '). Current subscribers count: ' + data.items[0].statistics.subscriberCount + ' subscribers!'};
            }
        }
        return { status: false, data: null };
    } catch(err) {
        console.log(err.message);
        return { status: false, data: null };
    }
};

module.exports = youtubeGetSubscribersCount;