const axios = require('axios');

const config = {
    headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
    }
};

const username = 'AREA Discord';

const discordSendMessage = async (areaID, { serviceParams }, data) =>
    await axios.post(serviceParams.webhookURL, { username, content: JSON.stringify(data) }, config);

module.exports = discordSendMessage;