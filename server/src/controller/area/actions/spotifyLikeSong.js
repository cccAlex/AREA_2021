const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'spotifyLikeSong';

const saveLikes = async (areaID, tracks) => {
    await new Area({ name: areaName, areaID, params: JSON.stringify(tracks) }).save();
    return { status: false, data: null };
};

const getDiff = (a1, a2) => a1.filter(elem1 => {
    for (const elem2 of a2) {
        if (elem2.id === elem1.id)
            return false;
    }
    return true;
});

const checkLikes = async (areaID, tracks, savedTracks) => {
    const newLikes = getDiff(tracks, savedTracks);
    const diff = newLikes.concat(getDiff(savedTracks, tracks));

    if (diff.length) {
        await Area.updateOne({ name: areaName, areaID }, { params: JSON.stringify(tracks) }).exec();

        if (newLikes.length)
            return { status: true, data: diff };
    }
    return { status: false, data: null };
};

const spotifyLikeSong = async (areaID, { serviceParams }) => {
    try {
        const area = await Area.findOne({ name: areaName, areaID }).exec();
        const { data } = await axios.get('https://api.spotify.com/v1/me/tracks?offset=0', {
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${serviceParams.access_token}` }
        });
        const tracks = data.items.map(
            ({ track: { id, name, artists, uri } }) => ({ id, name, artists: artists.map(({ name }) => name), uri })
        );

        return area ? checkLikes(areaID, tracks, JSON.parse(area.params)) : saveLikes(areaID, tracks);
    } catch(err) {
        console.log('SPOTIFY LIKE SONG ERROR:', err.message);
        return { status: false, data: null };
    }
};

module.exports = spotifyLikeSong;