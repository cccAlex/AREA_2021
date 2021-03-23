const {google} = require('googleapis');
const axios = require('axios');
const Area = require('../../../models/Area');

const areaName = 'GoogleCalendarAddEvent';

const client_id = process.env.GOOGLE_CALENDAR_CLIENT_ID;
const client_secret = process.env.GOOGLE_CALENDAR_CLIENT_SECRET;
const redirect_uri = process.env.GOOGLE_CALENDAR_REDIRECT_URI;

const auth = new google.auth.OAuth2(
    client_id, client_secret, redirect_uri);

const GoogleCalendarAddEvent = (areaID, {serviceParams}, data) => {
    auth.setCredentials(serviceParams.res.data);

    const eventStartTime = new Date();
    eventStartTime.setDate(eventStartTime.getDay() + 7);

    const eventEndTime = new Date();
    eventEndTime.setDate(eventEndTime.getDay() + 8);

    const calendar = google.calendar({version: 'v3', auth});
    const event = {
        summary: 'Area event occured',
        description: JSON.stringify(data),
        start: {
            dateTime: eventStartTime,
            timeZone: 'Europe/Paris',
        },
        end: {
            dateTime: eventEndTime,
            timeZone: 'Europe/Paris',
        },
        colorId: 1,
      }
    return new Promise((resolve, reject) => {
          calendar.events.insert({
            auth: auth,
            calendarId: 'primary',
            resource: event,
          }, function(err, event) {
            if (err) {
                reject(err);
                return;
            } else {
                console.log('Event created: %s', event.htmlLink);
                resolve(event);
            }
          });
    });
};

module.exports = GoogleCalendarAddEvent;