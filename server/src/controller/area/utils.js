const cron = require('node-cron');
const User = require('../../models/User');
const { encryptParams, decryptParams } = require('../../utils/cryptParams');
// actions
const spotifyLikeSong = require('./actions/spotifyLikeSong');
const youtubeGetNewestVideo = require('./actions/youtubeGetNewestVideo')
const youtubeGetTotalViewsCount = require('./actions/youtubeGetTotalViewsCount')
const youtubeGetSubscribersCount = require('./actions/youtubeGetSubscribersCount')
const youtubeGetNewestVideoFromPlaylist = require('./actions/youtubeGetNewestVideoFromPlaylist');
const checkCurrentWeather = require('./actions/checkCurrentWeather');
const getNewFile = require('./actions/getNewFile');
const GoogleCalendarUpdateEvents = require('./actions/GoogleCalendarUpdateEvents');
const GoogleCalendarRemoveEvents = require('./actions/GoogleCalendarRemoveEvents');
// reactions
const discordSendMessage = require('./reactions/discordSendMessage');
const areaBotMailer = require('./reactions/areaBotMailer');
const createFileDrive = require('./reactions/createFileDrive');
const youtubeLikeVideo = require('./reactions/youtubeLikeVideo');
const youtubeDislikeVideo = require('./reactions/youtubeDislikeVideo');
const spotifyAddToPlaylist = require('./reactions/spotifyAddToPlaylist');
const GoogleCalendarAddEvent = require('./reactions/GoogleCalendarAddEvent');

const encryptArea = ({ name, params, serviceName, serviceParams }) => ({
    name,
    params: encryptParams(params),
    serviceName,
    serviceParams: encryptParams(serviceParams)
});

const decryptArea = ({ name, params, serviceName, serviceParams }) => ({
    name,
    params: decryptParams(params),
    serviceName,
    serviceParams: decryptParams(serviceParams)
});

let allArea = [];
const pushArea = (area, task) => allArea.push({ area, task });
const pullArea = (areaID) => allArea = allArea.filter(({ area }) => area._id !== areaID);
const startArea = (areaID) => {
    for (const index in allArea) {
        if (allArea[index].area._id.toString() === areaID) {
            allArea[index].task.start();
            break;
        }
    }
};
const endArea = (areaID) => {
    for (const index in allArea) {
        if (allArea[index].area._id.toString() === areaID) {
            allArea[index].task.stop();
            break;
        }
    }
};

const areaList = {
    GoogleCalendarUpdateEvents,
    GoogleCalendarRemoveEvents,
    GoogleCalendarAddEvent,
    discordSendMessage,
    spotifyLikeSong,
    youtubeGetTotalViewsCount,
    youtubeGetSubscribersCount,
    youtubeGetNewestVideo,
    youtubeGetNewestVideoFromPlaylist,
    areaBotMailer,
    checkCurrentWeather,
    createFileDrive,
    getNewFile,
    youtubeLikeVideo,
    youtubeDislikeVideo,
    spotifyAddToPlaylist,
};

const createTask = (areaID, refreshTime, action, reaction) => cron.schedule(refreshTime, async () => {
    try {
        console.log("ACTION", action.name);
        const { status, data } = await areaList[action.name](areaID, action);

        if (status) {
            console.log("REACTION", reaction.name);
            await areaList[reaction.name](areaID, reaction, data);
        }
    } catch (error) {
        console.log(error.message);
    }
});

const recoverTasks = () => {
    return new Promise((resolve, reject) => {
        User.find({}, 'area')
            .exec()
            .then(async (users) => {
                if (!users) return resolve();

                for (const user of users) {
                    for (const area of user.area) {
                        const action = decryptArea(area.action);
                        const reaction = decryptArea(area.reaction);
                        const task = createTask(area._id, area.refreshTime, action, reaction);

                        pushArea(area, task);
                        task.start();
                    }
                }
                resolve();
            })
            .catch((err) => reject(err))
    });
};

const cronExpressions = {
    '10s': '*/10 * * * * *',
    '1min': '* * * * *',
    '2min': '*/2 * * * *',
    '5min': '*/5 * * * *',
    '10min': '*/10 * * * *',
    '15min': '*/15 * * * *',
    '30min': '*/30 * * * *',
    'hourly': '0 * * * *',
    'daily': '0 0 * * *',
    'weekly': '0 0 * * 0',
    'monthly': '0 0 1 * *',
};

const cronExpressionsArray = [
    { text: '10s', value: '*/10 * * * * *' },
    { text: '1min', value:'* * * * *' },
    { text: '2min', value:'*/2 * * * *' },
    { text: '5min', value:'*/5 * * * *' },
    { text: '10min', value:'*/10 * * * *' },
    { text: '15min', value:'*/15 * * * *' },
    { text: '30min', value:'*/30 * * * *' },
    { text: 'hourly', value:'0 * * * *' },
    { text: 'daily', value:'0 0 * * *' },
    { text: 'weekly', value:'0 0 * * 0' },
    { text: 'monthly', value:'0 0 1 * *' },
];

exports.encryptArea = encryptArea;
exports.decryptArea = decryptArea;
exports.pushArea = pushArea;
exports.pullArea = pullArea;
exports.startArea = startArea;
exports.endArea = endArea;
exports.createTask = createTask;
exports.recoverTasks = recoverTasks;
exports.cronExpressions = cronExpressions;
exports.cronExpressionsArray = cronExpressionsArray;