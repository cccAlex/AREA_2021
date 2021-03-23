const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'getNewFile';

const getNewFile = async (areaID, {params, serviceParams }) => {
    try {
        const area = await Area.findOne({ name: areaName, areaID }).exec();
        const { data } = await axios.get('https://www.googleapis.com/drive/v2/files?maxResults=1000', {
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${serviceParams.tokens.access_token}`}
        });
        
        let file_id;
        for(let i in data.items) {
            if (data.items[i].kind == "drive#file") {
                file_id = JSON.stringify(data.items[i].id);
                break;
            }
        }

        if (!area) {
            await new Area({ name: areaName, areaID, params: file_id}).save();
            return { status: false, data: null };
        }
        if (file_id != area.params) {
            await Area.updateOne({ name: areaName, areaID }, { params: file_id }).exec();
            return { status: true, data: 'New file, '+file_id+' created'};
        }
        return { status: false, data: null };         
    } catch(err) {
        console.log(err.message);
        return { status: false, data: null };
    }
};

module.exports = getNewFile;