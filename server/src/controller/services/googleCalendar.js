const {google} = require('googleapis');
const joi = require('../../plugins/joi');
const { addService } = require('./utils');

const client_id = process.env.GOOGLE_CALENDAR_CLIENT_ID;
const client_secret = process.env.GOOGLE_CALENDAR_CLIENT_SECRET;
const redirect_uri = process.env.GOOGLE_CALENDAR_REDIRECT_URI;

const SCOPES = ['https://www.googleapis.com/auth/calendar'];


const oAuth2Client = new google.auth.OAuth2(
    client_id, client_secret, redirect_uri);

const getGoogleCalendarAuthURL = (req, res) => res.send({ status: true, data: { url: getAuthUrl(oAuth2Client) } });

function getAuthUrl(oAuth2Client) {
  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  return authUrl;
}

const googleCalendarSignInSchema = joi.object({
    code: joi.string().required(),
    state: joi.string()
});

const googleCalendarSignIn = (req, res) => {
    const { error } = googleCalendarSignInSchema.validate(req.body);
    if (error) {
        return res.send({ status: false, data: error.message });
    }

    oAuth2Client.getToken(req.body.code)
        .then(async (data) => {
            await addService(res.locals.user._id, "Google Calendar", data)
            res.send({status: true, data})
        })
        .catch((err) => {
            res.send({ status: false, data: err.message })
        });
};

/**
 * Lists the next 10 events on the user's primary calendar.
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
function listEvents(auth) {
  const calendar = google.calendar({version: 'v3', auth});
  calendar.events.list('primary');
  calendar.events.list({
    calendarId: 'primary',
    timeMin: (new Date()).toISOString(),
    maxResults: 10,
    singleEvents: true,
    orderBy: 'startTime',
  }, (err, res) => {
    if (err) return console.log('The API returned an error: ' + err);
    const events = res.data.items;
    if (events.length) {
      console.log('Upcoming 10 events:');
      events.map((event, i) => {
        const start = event.start.dateTime || event.start.date;
        console.log(`${start} - ${event.summary}`);
      });
    } else {
      console.log('No upcoming events found.');
    }
  });
}


function addEvent() {
const event = {
  summary: 'Area event occured',
  description: "",
  start: {
      dateTime: eventStartTime,
      timeZone: 'France/Paris',
  },
  end: {
      dateTime: endEndTime,
      timeZone: 'France/Paris',
  },
  colorId: 1,
}

calendar.events.insert({
  auth: auth,
  calendarId: 'primary',
  resource: event,
}, function(err, event) {
  if (err) {
    console.log('There was an error contacting the Calendar service: ' + err);
    return;
  }
  console.log('Event created: %s', event.htmlLink);
});
}

exports.getGoogleCalendarAuthURL = getGoogleCalendarAuthURL;
exports.googleCalendarSignIn = googleCalendarSignIn;