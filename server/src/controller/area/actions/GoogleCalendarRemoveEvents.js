const {google} = require('googleapis');
const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'GoogleCalendarRemoveEvents';

const client_id = process.env.GOOGLE_CALENDAR_CLIENT_ID;
const client_secret = process.env.GOOGLE_CALENDAR_CLIENT_SECRET;
const redirect_uri = process.env.GOOGLE_CALENDAR_REDIRECT_URI;

const auth = new google.auth.OAuth2(
    client_id, client_secret, redirect_uri
);

const getEvents = (serviceParams) => {
    return new Promise((resolve, reject) => {
        auth.setCredentials(serviceParams.res.data);
    
        const calendar = google.calendar({version: 'v3', auth});
    
        calendar.events.list({
            calendarId: 'primary',
            timeMin: (new Date()).toISOString(),
            maxResults: 10,
            singleEvents: true,
            orderBy: 'startTime',
            showDeleted: false,
        }, (err, res) => {
            if (err) return reject(err);
            
            const events = res.data.items;
    
            resolve(events.map(({ id, description, summary, timeZone, etag, updated, kind }) => ({ id, description, summary, timeZone, etag, updated, kind })));
        });
    });
};

const savedEvents = async (areaID, events) => {
    await new Area({ name: areaName, areaID, params: JSON.stringify(events) }).save();
    return { status: false, data: null };
};

const getDiff = (a1, a2) => a1.filter(elem1 => {
    for (const elem2 of a2) {
        if (elem2.id === elem1.id)
            return false;
    }
    return true;
});

const checkEvents = async (areaID, events, savedEvents) => {
    const deletedEvents = getDiff(savedEvents, events);
    const diff = deletedEvents.concat(getDiff(events, savedEvents));

    if (diff.length) {
        await Area.updateOne({ name: areaName, areaID }, { params: JSON.stringify(events) }).exec();

        if (deletedEvents.length) {
            console.log(diff);
            return { status: true, data: diff };
        }
    }
    return { status: false, data: null };
};

const GoogleCalendarRemoveEvents = async (areaID, {serviceParams}) => {
    try {
        const area = await Area.findOne({ name: areaName, areaID }).exec();
        const events = await getEvents(serviceParams);
        return area ? checkEvents(areaID, events, JSON.parse(area.params)) : savedEvents(areaID, events);
    } catch(err) {
        console.log('GOOGLE CALENDAR DELETE EVENT ERROR:', err.message);
        return { status: false, data: null };
    }
};

module.exports = GoogleCalendarRemoveEvents;