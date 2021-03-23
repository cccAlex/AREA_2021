const axios = require('axios');

const services = [];

const aboutJSON = (req, res) => {
    let host = null;

    axios.get('https://api.ipify.org/?format=json')
        .then(({ data: { ip } }) => host = ip)
        .catch(() => {})
        .finally(() => res.send({
            client: { host: host || req.headers['x-forwarded-for'] || req.ip.replace('::ffff:', '') || req.connection.remoteAddress || '127.0.0.1' },
            server: {
                current_time: Date.now(),
                services: [
                    {
                        'name': 'Spotify',
                        'actions': [
                            {
                                'name': 'spotifyLikeSong',
                                'description': 'The user likes a song on spotify'
                            }
                        ],
                        'reaction': [
                            {
                                'name': 'spotifyAddToPlaylist',
                                'description': 'Add all song that user like'
                            }
                        ]
                    },
                    {
                        'name': 'Google Drive',
                        'action': [
                            {
                                'name': 'getNewFile',
                                'description': 'Get the event of new add file',
                            },
                        ],
                        'reaction': [
                            {
                                'name': 'createFileDrive',
                                'description': 'Create a new file in your drive'
                            }
                        ]
                    },
                    {
                        'name': 'Google Calendar',
                        'actions': [
                            {
                                'name': 'GoogleCalendarUpdateEvents',
                                'description': 'Update the event in the calendar'
                            },
                            {
                                'name': 'GoogleCalendarRemoveEvents',
                                'description': 'Remove the event in the calendar'
                            },
                            
                        ],
                        'reaction': [
                            {
                                'name': 'GoogleCalendarAddEvent',
                                'description': 'Add an event in the calendar'
                            }
                        ]
                    },
                    {
                        'name': 'Youtube',
                        'actions': [
                            {
                                'name': 'youtubeGetNewestVideo',
                                'description': 'Get newest video of a specific youtube channel'
                            },
                            {
                                'name': 'youtubeGetSubscribersCount',
                                'description': 'Set a milestone of subscribers for your channel'
                            },
                            {
                                'name': 'youtubeGetTotalViewsCount',
                                'description': 'Set a milestone of total views for your channel'
                            },
                            {
                                'name': 'youtubeGetNewestVideoFromPlaylist',
                                'description': 'Get the event of new video in the selected playlist'
                            }
                        ],
                        'reaction': [
                            {
                                'name': 'youtubeLikeVideo',
                                'description': 'like a video'
                            },
                            {
                                'name': 'youtubeDislikeVideo',
                                'description': 'dislike a video'
                            } 
                        ]
                    },
                    {
                        'name': 'Weather',
                        'actions': [
                            {
                                'name': 'checkCurrentWeather',
                                'description': 'Check if its raining | snowing | tempest in the specified city'
                            },
                        ]
                    },
                    {
                        'name': 'Discord',
                        'reactions': [
                            {
                                'name': 'discordSendgMessage',
                                'description': 'Sends a message depending on the action to the discord channel (discord webhookURL)'
                            },
                        ]
                    },
                    {
                        'name': 'Area Mailer',
                        'reactions': [
                            {
                                'name': 'areaBotMailer',
                                'description': 'Sends a mail depending on the action to your email/specified email'
                            },
                        ]
                    },
                ],
            }
        }));
};

module.exports = aboutJSON;