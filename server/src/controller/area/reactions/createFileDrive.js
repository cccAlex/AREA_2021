const axios = require('axios');

const client_id = process.env.GOOGLE_GMAIL_CLIENT_ID;

const createFileDrive = async (areaID, { params, serviceParams }, actionData) => {
    try {

        const regex = /[|<>:"?*. ]/g;
        console.log(actionData)
        actionData = JSON.stringify(actionData).replace(regex, '_');
        const body = {
            name: actionData,
            mymeType: "text/plain",
        }
        const { data } = await axios.post('https://www.googleapis.com/drive/v3/files?key=' + client_id + '&uploadType=multipart', body, {
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${serviceParams.tokens.access_token}`, Accept: 'application/json' }
        });

        return { status: false, data: data };

    } catch (err) {
        console.log(err.message);
        return { status: false, data: null };
    }
};

module.exports = createFileDrive;